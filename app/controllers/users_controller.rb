class UsersController < ApplicationController
  before_action :find_user, only: :products_of_user
  before_action :products_of_user, only: [:index, :show]

  def index
    # PLACEHOLDER
    # NEEDS A WAY TO FIND RETURN USER ACCORDING TO SESSION
    # OR MAKE A DIFFERENT ACTION FOR DASHBOARD THAT TAKES AN ID
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save

    redirect_to user_path(@user)
  end

  def edit
    # PLACE HOLDER - SHINY STUFF THAT ISN'T REQUIRED
  end

  def find_user
    @user = User.find(session[:user_id])
  end

  def products_of_user
    user_products = @user.products.to_a
    @product_ids = []
    user_products.each do |product|
      @product_ids << product.id
    end
    order_items_by_user
  end

  def order_items_by_user
    @order_items = []
    @product_ids.each do |product_id|
      @order_items << OrderItem.where(product_id: product_id)
    end
    if @order_items.count > 1
      return @order_items
    else
      @order_items = nil
    end
  end

  def index
    # if orders.order_items.product_id == user.products.ids
    @orders = []
    if @order_items.nil?
      puts "No Current Orders"
    else
      @order_items.each do |order_item|
        @orders << Order.where(id: order_item.first.order_id)
        # still need to account for qty of order item
        @orders.uniq!
      end
    end
  end

  def show
    @orders.find(params[:order_id])
  end

  private

  def user_params
    params.require(:review).permit(:username, :email, :password, :password_confirmation)
  end

end
