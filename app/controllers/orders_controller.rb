require 'httparty'

class OrdersController < ApplicationController
  before_action :find_order, except: [ :index, :new, :create, :empty]

  CALLBACK_URL = "http://localhost:3000/quote"

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
    packages, origin, destination = prepare_request
    @order_items = @order.order_items

    response = HTTParty.get(CALLBACK_URL,
      body: { packages: packages, 
              origin: origin, 
              destination: destination, 
            } 
          )

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

  def prepare_request
    @order_items = @order.order_items
    products = []
    @order_items.each { |item| products << Product.find_by(id: item.product_id) }

    packages = []
    origin = {}
    products.each do |product|
      packages <<
      {
        weight: product.weight,
        height: product.height,
        width: product.width
      }

      user = User.find_by(id: product.user_id)

      origin[:city] = user.city
      origin[:state] = user.state
      origin[:country] = user.country
      origin[:zip] = user.zip
    end

    destination = {}
    destination[:country] = "US"
    destination[:state] = params[:order][:state]
    destination[:city] = params[:order][:city]
    destination[:zip] = params[:order][:zipcode]
    
    return packages, origin, destination
  end
end
