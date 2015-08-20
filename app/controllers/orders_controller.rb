class OrdersController < ApplicationController
  before_action :find_order, except: [ :index, :new, :create, :empty]
  COUNTRY = "US"
  PENGUIN_ALL_RATES_URI = "http://localhost:4000/get_all_rates"

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
       @order.email = params[:order][:email]
       @order.address1 = params[:order][:address1]
       @order.address2 = params[:order][:address2]
       @order.city = params[:order][:city]
       @order.state = params[:order][:state]
       @order.zip = params[:order][:zip]
       @order.card_last_4 = params[:order][:card_number][-4, 4]
       @order.ccv = params[:order][:ccv]
       @order.card_exp = params[:order][:card_exp]
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
    grouped_items = @order_items.group_by { |order_item| order_item.product.user }

    origin_package_pairs = []
    grouped_items.each do |merchant, items|
      origin_package = {}
      origin_package["origin"] = create_location(merchant)
      origin_package["packages"] = []
      items.each do |item|
        origin_package["packages"] << create_package(item)
      end
      origin_package_pairs << origin_package
    end

    destination = create_location(@order)

    all_rates = []
    origin_package_pairs.each do |distinct_origin|
      distinct_origin["destination"] = destination
      shipment = {}
      shipment["shipment"] = distinct_origin

      json_shipment = shipment.to_json

      results = HTTParty.get(PENGUIN_ALL_RATES_URI, query: { json_data: json_shipment } ).parsed_response
      all_rates += results
    end

    @calculated_rates = []
    grouped_rates = all_rates.group_by { |rate| rate["service_name"] }
    grouped_rates.each do |service, service_rate_pairs|
      rate = {}
      rate["service_name"] = service
      rate["total_price"] = service_rate_pairs.inject(0) { |sum, rate| sum + rate["total_price"] }
      rate["delivery_date"] = service_rate_pairs.last["delivery_date"]
      @calculated_rates << rate
    end

    @subtotal = 0
    @shipping_cost = session[:shipping_option] ? session[:shipping_option]["total_price"]/100.0 : 0

    render :shipping
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
        update_inventory(@order)
        redirect_to order_confirmation_path(@order)
        ## make API call to log chosen shipping
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

  def create_location(object)
    location = {}
    location["country"] = COUNTRY
    location["state"] = object.state
    location["city"] = object.city
    location["zip"] = object.zip
    return location
  end

  def create_package(item)
    package = {}
    product = item.product
    package["weight"] = product.weight_in_gms

    dimensions = [product.length_in_cms, product.width_in_cms, product.height_in_cms]
    package["dimensions"] = dimensions
    return package
  end
end
