class UsersController < ApplicationController
  before_action :find_user, only: :show
  # before_action :product_ids_from_user, only: [:index, :show]

  def find_user
    @user = User.find(session[:user_id])
  end

  def show
    # associations
    product_ids = User.product_ids_from_user(@user)
    order_items = User.order_items_from_products(product_ids)
    @orders = User.orders_from_order_items(order_items)

    # needed for a count of orders based on status
    # an array of Order objects
    @pending_orders = Order.by_status(@orders, "pending")
    @paid_orders = Order.by_status(@orders, "paid")
    @completed_orders = Order.by_status(@orders, "completed")
    @canceled_orders = Order.by_status(@orders, "canceled")

    @total_revenue = order_items.nil? ? 0 : revenue(order_items)
    # why $50 and not $55?
    @paid_revenue = User.orders_items_from_order(@paid_orders, @user).nil? ? 0 : revenue(User.orders_items_from_order(@paid_orders, @user))
    @completed_revenue = User.orders_items_from_order(@completed_orders, @user).nil? ? 0 : revenue(User.orders_items_from_order(@completed_orders, @user))
  end

  def new
    if session[:user_id].nil?
      @user = User.new
      render :new
    else
      flash[:alert] = "You can't make a new account while you're currently logged in."
      redirect_to root_path
    end
  end

  def create # create a new logged in user
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id # creates a session - they are logged in
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def index # returns array of order assoc w/ order items of user
    @orders = []
    if @order_items.nil?
      puts "No Current Orders"
    else
      @order_items.each do |order_item|
        @orders << Order.where(id: order_item.first.order_id)
        @orders.uniq!
      end
    end
  end

  private

  def self.model
    User
  end # USED FOR RSPEC SHARED EXAMPLES

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def revenue(order_items)
    order_items.reduce(0) { |sum, n| sum + (n.product.price * n.quantity)}
  end
end
