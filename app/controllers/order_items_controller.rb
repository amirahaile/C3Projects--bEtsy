class OrderItemsController < ApplicationController
  before_action :find_order_item, only: [:destroy, :qty_decrease, :qty_increase]
  before_action :find_order, only: [:create]

  def find_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def find_order
    @order = Order.find(session[:order_id])
  end

  def index # this an alias
    create
  end

  def create # this is for adding items to the cart
    if OrderItem.find_by(product_id: params[:id])
      @order_item = OrderItem.find_by(product_id: params[:product_id])
      @order_item.quantity += 1
      @order_item.save
      @order.order_items << @order_item
    else
      @order_item = OrderItem.create!(order_id: @order.id, product_id: params[:product_id])
      @order.order_items << @order_item
    end

    # handling for updating a shipping estimate
    if @order.order_items.count >= 2 && @order.shipping_price
      update_shipping
    end

    redirect_to order_path(@order), method: :get
  end

  def destroy # this is for removing items from the cart
    @order_item.destroy
    @order_item.save

    # handling for updating a shipping estimate
    if @order && @order.order_items.count >= 1 && @order.shipping_price
      update_shipping
    end

    redirect_to order_path(@order)
  end

  def qty_decrease
    @order_item.quantity -= 1
    @order_item.save
    redirect_to :back rescue redirect_to order_path(@order_items.order)
  end

  def qty_increase
    @order_item.quantity += 1
    @order_item.save

    redirect_to :back rescue redirect_to order_path(@order_items.order)
  end

  private

  def update_shipping
    # make sure order record is up-to-date
    @order.reload

    # query the fedax api for updated shipping info & save to order
    response = fed_ax_quote_update_request

    # using update_attribute to bypass validations
    price = response["quote"]["total_price"]
    date = response["quote"]["delivery_date"]
    @order.update_attribute("shipping_price", price)
    @order.update_attribute("delivery_date", date)
  end

  def self.model
    OrderItem
  end
end
