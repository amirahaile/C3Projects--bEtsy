class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :payment]

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

  def payment
    @order.email = params[:order][:email]
    @order.address1 = params[:order][:address1]
    @order.address2 = params[:order][:address2]
    @order.city = params[:order][:city]
    @order.state = params[:order][:state]
    @order.zipcode = params[:order][:zipcode]
    @order.card_last_4 = params[:order][:card_number.split(//\)][-1, 4].join(",")
    @order.card_exp = params[:order][:card_exp]
    @order.status = "paid"
    @order.save
    update_inventory(@order)
  end

  def update_inventory(order)
    order.order_items.each do |order_item|
      order_item.product.inventory -= order_item.quantity
      order_item.product.update!
    end
  end
end
