class OrdersController < ApplicationController
  before_action :find_order, only: [:update, :destroy]
  before_action :empty_cart?, only: [:show]
  before_action :correct_order, only: [:index, :buyer]
  before_action :find_merchant, only: [:index, :buyer]

  include ApplicationHelper

  def new
    @order = Order.new
  end

  def create
    @order = Order.create(order_params)
    if @order.save
      redirect_to root_path #need to change this when we have other views
    else
      render :new
    end
  end

  def update
    @order.update(order_params)
    render :show
  end

  def quotes
    @order = Order.find(params[:id])
    buyer = order.buyer
    products = @order.order_items.map { |item| item.product }
    merchants = products.map { |product| product.user }
    parsed_responses = []

    merchants.each do |merchant|
      merchant_products = products.map { |product|  product if product.user_id == merchant.id}
      products_hash = {}
      merchant_products.each do |product|
        products_hash[merchant_products.index(product)] = product.for_shipping
      end

      # body for API request
      shipping_info = {
        body: {
          merchant: merchant.for_shipping,
          buyer: buyer.for_shipping,
          products: products_hash
        }
      }

      response = HTTParty.post('heroku url', shipping_info)
      parsed_responses << response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    end

    # NOTE: how will we separate UPS from USPS, etc. for the view
    # send the API response to view
    render :shipping_quotes
  end

  def quotes=
    # saves the shipping selection to the db
    redirect_to buyer_confirmation_path(@buyer.order_id)
  end

  def index # merchant
    @all_items = @merchant.order_items

    @pend = @all_items.where(status: "pending")
    @paid = @all_items.where(status: "paid")
    @ship = @all_items.where(status: "complete")

    @pend_total = @all_items.where(status: "pending").pluck(:total_price)
    @paid_total = @all_items.where(status: "paid").pluck(:total_price)
    @ship_total = @all_items.where(status: "complete").pluck(:total_price)
  end

  def show # shopping cart
    @order_items = current_order.order_items
    @order = Order.find(session[:order_id])
    @total = @order.subtotal
  end

  def buyer
    @buyer =  Buyer.find(params[:id])
  end

  # check to see if the correct user is logged in
  # renamed the method since I needed the user_id, not the id
  def correct_order
    @user = User.find(params[:user_id])
    redirect_to(root_url) unless current_user?(@user)
  end

  private

    def order_params
      params.require(:order).permit(:id)
    end

    def find_order
      @order = Order.find(id: order_params[:id])
    end

    def empty_cart?
      if session[:order_id].nil?
        render :empty
      elsif session[:order_id].nil? == false
        @order = Order.find(session[:order_id])
        if @order.order_items.count == 0
          render :empty
        end
      end
    end

    def find_merchant
      @merchant = User.find(params[:user_id])
    end
end
