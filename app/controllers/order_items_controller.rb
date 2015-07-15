class OrderItemsController < ApplicationController
  before_action :find_order_item, only: [:destroy]

  def find_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def destroy
    @order_item.destroy
    @order_item.save
    redirect_to order_path
  end

end
