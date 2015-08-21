require 'httparty'

class OrdersController < ApplicationController
  before_action :find_order, except: [:index, :new, :create, :empty]

  def find_order
    @order = Order.find(params[:id])
  end

  def index; end

  def show
    if session[:order_id] == @order.id
      if @cart_quantity > 0
        @order_items = @order.order_items
      else
        render :index
      end
    else
      redirect_to root_path
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
      @order.email = params[:order][:email]
      @order.address1 = params[:order][:address1]
      @order.address2 = params[:order][:address2]
      @order.city = params[:order][:city]
      @order.state = params[:order][:state]
      @order.zipcode = params[:order][:zipcode]
      @order.card_last_4 = params[:order][:card_number][-4, 4]
      # @order.ccv = params[:order][:ccv]
      @order.card_exp = params[:order][:card_exp]
      @order.status = "paid"
      if @order.save # move and account for whether the order is cancelled?
        update_inventory(@order)
        session[:order_id] = nil # emptying the cart after confirming order
        redirect_to order_confirmation_path(@order)
      else
        render :payment
      end
    else
      redirect_to order_path(@order), notice: "#{@order_item.product.name} only has #{@order_item.product.inventory} item(s) in stock."
    end
  end

  def confirmation
    session[:order_id] = nil # clears cart
    @purchase_time = Time.now
    @order_items = @order.order_items
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

  def shipping; end

  def estimate
    # update order with customer's location selections
    # using update_attribute to bypass validations
    city, state, zip = prepare_estimate
    @order.update_attribute("city", city)
    @order.update_attribute("state", state)
    @order.update_attribute("zipcode", zip)
    # query api
    response = fed_ax_quote_request

    unless response.nil?
      if response["message"]
        flash[:error] = response["message"]
        return redirect_to order_path(status: 'estimate')
      else
        @quotes = (response["quotes"]["ups"] + response["quotes"]["usps"])
        @quotes = @quotes.sort_by { |k| k["total_price"] }
      end

      params[:status] = 'shipping'
      render :show
    end
  end

  def ship_update
    @order_items = @order.order_items
    price, type, date, carrier = prepare_ship_update

    # update order with customer's shipping selection
    # using update_attribute to bypass validations
    @order.update_attribute("shipping_price", price)
    @order.update_attribute("shipping_type", type)
    @order.update_attribute("delivery_date", date)
    @order.update_attribute("carrier", carrier)

    render :show
  end

  private

  def prepare_estimate
    city = params.require(:order).require(:city)
    state = params.require(:order).require(:state)
    zip = params.require(:order).require(:zipcode)

    return city, state, zip
  end

  def prepare_ship_update
    content = params.require(:order).require(:shipping_type)
    content = eval(content.gsub(/\"/, "'")) # FIXME: this is extremely unsafe

    price = content["total_price"]
    type = content["service_type"]
    date = content["delivery_date"]
    carrier = content["carrier"]

    return price, type, date, carrier
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
