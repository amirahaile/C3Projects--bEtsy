class OrdersController < ApplicationController
  before_action :find_order, except: [ :index, :new, :create, :empty]

  def find_order
    @order = Order.find(params[:id])
  end

  def index; end

  def show
    if @cart_quantity > 0
      @order_items = @order.order_items
    else
      render :index
    end
  end

  # view for an empty cart
  def empty; end

  # same as :show; any way to conslidate?
  def payment
    @order_items = @order.order_items
  end

  def update
    # check for appropriate amount of inventory before accepting payment
    update_inventory(@order)

    if @enough_inventory
      @order.email = params[:order][:email]
      @order.address1 = params[:order][:address1]
      @order.address2 = params[:order][:address2]
      @order.city = params[:order][:city]
      @order.state = params[:order][:state]
      @order.zipcode = params[:order][:zipcode]
      @order.card_last_4 = params[:order][:card_number][-4, 4]
      @order.card_exp = params[:order][:card_exp]
      @order.status = "paid"
      @order.save! # move and account for whether the order is canceled?
      redirect_to order_confirmation_path(@order)
    else
      redirect_to :back rescue redirect_to order_path(@order)
      flash.now[:error] = "#{order_item.product} only has #{order_item.quantity} item in stock."
    end
  end

  def confirmation
    @order_items = @order.order_items
  end

  def destroy
    @order.status = "cancelled"
    @order.save!
    session[:order_id] = nil
    redirect_to root_path
  end

  private

  def update_inventory(order)
    order.order_items.each do |order_item|
      product = Product.find(order_item.product_id)
      @enough_inventory = true

      if product.inventory >= order_item.quantity
        product.inventory -= order_item.quantity
        product.save
      else
        @enough_inventory = false
      end
    end
  end
end
