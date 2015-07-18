class OrdersController < ApplicationController
  before_action :find_order, except: [:new, :create]

  def find_order
    @order = Order.find(params[:id])
  end

  # connect products order item controller to instantiate an order item
  # and then to the order controller to shovel into the order
  def new
    @order = Order.new
    # triggered by the 'add to cart' button on Products#show
  end

  def find_or_create
    @order = Order.where(params[:id]).first_or_create do |order|
      @order_item = OrderItem.create!(product_id: (Product.find(params[:id]).id)
      order.order_items << @order_item
      order.save
    end
    # redirect_to #order_cart_path
  end

  def show
    @order_items = @order.order_items
  end

  def payment
    # check for appropriate amount of inventory before accepting payment
    update_inventory(@order)
    @order.email = params[:order][:email]
    @order.address1 = params[:order][:address1]
    @order.address2 = params[:order][:address2]
    @order.city = params[:order][:city]
    @order.state = params[:order][:state]
    @order.zipcode = params[:order][:zipcode]
    @order.card_last_4 = params[:order][:card_number.split(//)][-1, 4].join(",")
    @order.card_exp = params[:order][:card_exp]
    @order.status = "paid"
    @order.save # move and account for whether the order is canceled
  end

  def confirmation
    @order_items = @order.order_items
  end

  private

  def update_inventory(order)
    order.order_items.each do |order_item|
      if order_item.product.inventory >= order_item.quantity
        order_item.product.inventory -= order_item.quantity
        order_item.product.update!
      else
        redirect_to :back rescue redirect_to order_path(@order), flash.now[:error] = "#{order_item.product} only has #{order_item.quantity} item in stock."
      end
    end
  end
end
