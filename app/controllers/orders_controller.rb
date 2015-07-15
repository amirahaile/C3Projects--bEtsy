class OrdersController < ApplicationController

  def new
    # triggered by the 'add to cart' button on Products#show
  end

  def create
    # see :new
  end

  def show
    order = Order.find(params[:id])
    @order_items = order.order_items
  end
end
