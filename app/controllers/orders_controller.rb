class OrdersController < ApplicationController
  before_action :find_order, except: [ :index, :new, :create, :empty]

  PENGUIN_LOG_CHOICE_URI  = Rails.env.production? ?
    "http://https://whispering-shore-8365.herokuapp.com/log_shipping_choice" :
    "http://localhost:4000/log_shipping_choice"

  def find_order
    @order = Order.find(params[:id])
  end

  def index; end

  def show
    if session[:order_id] == @order.id
      # if @cart_quantity > 0
      if @order.order_items
        @order_items = @order.order_items
      else
        render :index # there is session[:order_id], but no items in cart
      end
    else
      redirect_to root_path # no session[:order_id]
    end
  end

  # view for an empty cart
  def empty; end

  # same as :show; any way to conslidate?
  def payment
    # Guard: Throws flash errors if buyer clicks checkout while items in cart
    # have a greater requested qty than the listed product inventory in database.
    @order.order_items.each do |item|
      product = Product.find(item.product_id)
      if product.inventory < item.quantity
        flash[item.product.name] = "#{item.product.name} only has #{item.product.inventory} item(s) in stock."
      end
    end
    unless flash.empty?
      redirect_to order_path(@order)
    end
    # End of Guard

    @order_items = @order.order_items
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def update
     # check for appropriate amount of inventory before accepting payment
     check_inventory(@order)

     if @enough_inventory
       @order.update(order_params)
       @order.card_last_4 = @order.card_number[-4, 4]
       if @order.save # move and account for whether the order is cancelled?
         redirect_to shipping_path(@order)
       else
         render :payment
       end
     else
       redirect_to order_path(@order), notice: "#{@order_item.product.name} only has #{@order_item.product.inventory} item(s) in stock."
     end
   end

  def shipping
    @order_items = @order.order_items

    @calculated_rates = PenguinShipperInterface.process_order(@order)

    if @calculated_rates.first.keys.length > 1
      @subtotal = 0
      @shipping_cost = session[:shipping_option] ? session[:shipping_option]["total_price"]/100.0 : 0
      render :shipping
    elsif @calculated_rates.first.values.first == "422"
      redirect_to :shipping, notice: "Error in shipping choice. Please try again."
    elsif @calculated_rates.first.values.first == "408"
      redirect_to :shipping, notice: "We could not process your request in a timely manner. Please try again later."
    elsif @calculated_rates.first.values.first == "bad"
      redirect_to :shipping, notice: "NOPE. Please try again."
    end
  end

  def update_total
    ## this is how :shipping_option is getting passed in the params before eval
    ## "{\"service_name\"=>\"UPS Next Day Air\", \"total_price\"=>15985, \"delivery_date\"=>\"2015-08-21T00:00:00.000+00:00\"}"

    ## WARNING eval is an unsafe method as it will run commands in the evaluated object
    ## FIXME change this to a safer way to convert the params data to something we can use
    session[:shipping_option] = eval(params["shipping_option"])

    redirect_to :shipping
  end

  def finalize
    # secondary check for appropriate amount of inventory before accepting payment
    check_inventory(@order)

    if @enough_inventory
      shipping_option = session[:shipping_option]
      @order.shipping_service = shipping_option["service_name"]
      @order.shipping_cost = shipping_option["total_price"]/100.0

      @order.status = "paid"

      if @order.save # move and account for whether the order is cancelled?

        shipping_choice = {}
        shipping_choice["shipping_choice"] = {} # create wrapper for JSON
        shipping_choice["shipping_choice"]["shipping_service"] = @order.shipping_service
        # multiply by 100 since PenguinShipper stores costs in cents
        shipping_choice["shipping_choice"]["shipping_cost"] = @order.shipping_cost * 100
        shipping_choice["shipping_choice"]["order_id"] = @order.id
        shipping_choice = shipping_choice.to_json

        response = HTTParty.post(PENGUIN_LOG_CHOICE_URI, query: { json_data: shipping_choice })
        case response.code
        when 201
          update_inventory(@order)
          redirect_to order_confirmation_path(@order)
        when 422
          redirect_to :shipping, notice: "Error in shipping choice. Please try again."
        when 408
          redirect_to :shipping, notice: "We could not process your request in a timely manner. Please try again later."
        else
          redirect_to :shipping, notice: "NOPE. Please try again."
        end
      else
        redirect_to :shipping, notice: "Order could not be saved. Please try again."
      end
    else # if not enough_inventory
      redirect_to order_path(@order), notice: "#{@order_item.product.name} only has #{@order_item.product.inventory} item(s) in stock."
    end
  end

  def confirmation
    session[:order_id] = nil # clears cart
    @subtotal = 0
    @purchase_time = Time.now
    @order_items = @order.order_items

    render :confirmation
  end

  def destroy
    @order.status = "cancelled"
    @order.save!
    session[:order_id] = nil

    if session[:user_id]
      redirect_to user_path(session[:user_id]), notice: "The order was cancelled and an (pretend) email has be sent to the buyer."
    else
      redirect_to root_path
    end
  end

  def completed
      @order.status = "complete"
      @order.save!
    redirect_to user_path(@user), notice: "You've shipped and completed order ##{@order.id}!"
  end

  private

  def order_params
    params.require(:order).permit(:email, :address1, :address2, :city, :state,
      :zip, :card_number, :ccv, :card_exp)
  end

  def self.model
    Order
  end # USED FOR RSPEC SHARED EXAMPLES

  def check_inventory(order)
    @enough_inventory = true
    order.order_items.each do |order_item|
      product = Product.find(order_item.product_id)

      if product.inventory < order_item.quantity
        @enough_inventory = false
        @order_item = order_item
      end
    end
  end

  def update_inventory(order)
    order.order_items.each do |order_item|
      product = Product.find(order_item.product_id)
      product.inventory -= order_item.quantity
      product.save
    end
  end
end
