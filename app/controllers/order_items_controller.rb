class OrderItemsController < ApplicationController
  before_action :find_order_item, only: [:destroy, :qty_decrease, :qty_increase]

  def find_order_item
    @order_item = OrderItem.find(params[:id])
  end

  # def create
    # @order_item = OrderItem.create!(quantity: :qty, order_id: :id, product_id: params[:id])
    # redirect_to order_path
  # end

  def destroy
    @order_item.destroy
    @order_item.save
    redirect_to order_path
  end

  def qty_decrease
    @order_item.quantity -= 1
    @order_item.save

    redirect_to :back rescue redirect_to order_items_decrease_path
  end

  def qty_increase
    @order_item.quantity += 1
    @order_item.save

    redirect_to :back rescue redirect_to order_items_increase_path
  end
end
