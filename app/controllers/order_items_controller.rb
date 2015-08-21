class OrderItemsController < ApplicationController
  before_action :find_order_item, only: [:destroy, :qty_decrease, :qty_increase]
  before_action :find_order, only: [:create]

  def find_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def find_order
    @order = Order.find(session[:order_id])
  end

  def index
    create
  end

  def create
    # FIXME is this checking for the current order_id? (it isn't!)
    if OrderItem.find_by(product_id: params[:id])
      @order_item = OrderItem.find_by(product_id: params[:product_id])
      @order_item.quantity += 1
      @order_item.save
      @order.order_items << @order_item
    else
      @order_item = OrderItem.create!(order_id: @order.id, product_id: params[:product_id])
      @order.order_items << @order_item
    end
    # OPTIMIZE why do you need to specify the method get here?
    redirect_to order_path(@order), method: :get
  end

  def destroy
    @order_item.destroy
    @order_item.save
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

  def self.model
    OrderItem
  end
end
