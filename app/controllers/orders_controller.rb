class OrdersController < ApplicationController
  before_action :find_order, except: [ :index, :new, :create, :empty]
  COUNTRY = "US"
  PENGUIN_ALL_RATES_URI = "http://localhost:4000/get_all_rates"

  def find_order
    @order = Order.find(params[:id])
  end

  def index
  end

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
    # raise
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

      response = HTTParty.get(PENGUIN_ALL_RATES_URI, query: { json_data: json_shipment } )
      all_rates += response
    end

    ## make API calls

    ## render order details and list of shipping options
    ## be able to choose shipping option and see updated total
    ## submit final order with chosen shipping option

    ## redirect to finalize_path
  end

  # def finalize
  #   @order.status = "paid"
  #   session[:order_id] = nil # emptying the cart after confirming order
  #   update_inventory(@order)

  #   ## make API call to log chosen shipping
  #   ## redirect_to order_confirmation_path
  # end

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
