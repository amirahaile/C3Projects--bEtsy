class OrdersController < ApplicationController
  before_action :find_order, only: [:show]

  def find_order
    @order = Order.find(params[:id])
  end

  def new
    # triggered by the 'add to cart' button on Products#show
  end

  def create
    # see :new
  end

  def show
    @order_items = @order.order_items
  end
end
