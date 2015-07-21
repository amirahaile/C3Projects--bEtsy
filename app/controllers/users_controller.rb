class UsersController < ApplicationController
  before_action :find_user, only: [:index, :show]
  after_action :products_in_orders, only: :products_of_user

  def find_user
    @user = User.find(session[:user_id])
  end

  def products_of_user
    user_products = @user.products
    @product_ids = []
    user_products.each do |product|
      @product_ids << product.id
    end
    return @product_ids
  end

  def order_items_by_user
    @order_items = []
    @product_ids.each do |product_id|
      @order_items << OrderItems.where(product_id: product_id)
    end
    return @order_items
  end

  def index
    # if orders.order_items.product_id == user.products.ids
    @orders = []
    @order_items.each do |order_item|
      @orders << order_item.order
      @orders.uniq!
    end
    return @orders
  end

  def show
    @orders.find(params[:order_id])
  end

end
