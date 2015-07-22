class UsersController < ApplicationController
  before_action :find_user, only: :products_of_user
  before_action :products_of_user, only: [:index, :show]

  def find_user
    @user = User.find(session[:user_id])
  end

  def show
    @user = User.find(params[:id])

    # return array of ActiveRecord::Relation objects that hold OrderItem objects
    products_of_user # @order_items

    find_orders(@order_items) # @orders
    separate_by_status(@orders) # @pending, @paid, @completed, @canceled
    @total_revenue = @order_items.nil? ? 0 : revenue(@order_items)

    # why $50 and not $55?
    @paid_revenue = find_orders_items_from_order(@paid).nil? ? 0 : revenue(find_orders_items_from_order(@paid))
    @completed_revenue = find_orders_items_from_order(@completed).nil? ? 0 : revenue(find_orders_items_from_order(@completed))
  end

  def new
    @user = User.new
  end

  def create # create a new logged in user
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id # creates a session - they are logged in
      redirect_to user_path(@user) # WHERE DO WE WANT THIS TO REDIRECT TO?
      # redirect_to root_path # with a message that they successfully created an account?
    else
      error_check_for("username")
      error_check_for("email")
      error_check_for("password")
      error_check_for("password_confirmation")
        # Would we use the flash.now to display the individual errors?
        # Should we reference the individual errors in the views via the instance variable?
      render :new
    end
  end

  def edit
    # PLACE HOLDER - SHINY STUFF THAT ISN'T REQUIRED
  end

  def products_of_user # gives array of product id's assoc w/ user
    user_products = @user.products.to_a
    @product_ids = []
    user_products.each do |product|
      @product_ids << product.id
    end
    order_items_from_products # calls next method
  end

  def order_items_from_products
    # an array of ActiveRecord::Relation objects that hold OrderItem objects
    @order_items = []
    @product_ids.each do |product_id|
      @order_items << OrderItem.where(product_id: product_id)
    end

    @order_items.reject! { |relation| relation.empty? }

    # checks if there are OrderItems
    unless @order_items.empty?
      return @order_items
    else
      @order_items = nil
    end
  end

  def index # returns array of order assoc w/ order items of user
    if @order_items.nil?
      puts "No Current Orders"
    else
      find_orders(@order_items)
      return @orders
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def nil_flash_errors
    flash.now[:username_error] = nil
    flash.now[:email_error] = nil
    flash.now[:password_error] = nil
    flash.now[:password_confirmation_error] = nil
  end

  # NOTE TO SELF: This should actually be a method inside the views helper.
  # Flash is usually only used for messages at the top of pages.
  # They work for this, but conventionally they are not used like how I am using them here. - Brandi
  def error_check_for(element)
    if @user.errors[element].any?
      flash.now[(element + "_error").to_sym] = (@user.errors.messages[element.to_sym][0].capitalize + ".")
    end
  end

  # finds OrderItem objects of similar Order status
  def find_orders_items_from_order(orders_by_status)
    if orders_by_status != []
      order_items = []
      orders_by_status.each do |order|
        order_items << OrderItem.where(order_id: order.id)
      end

      order_items
    else
      nil
    end
  end

  def find_orders(order_items)
    @orders = []
    if order_items.nil?
      return @orders
    else
      order_items.each do |item|
        # access via #first because it's inside of an ActiveRecord::Relation
        @orders << Order.find(item.first.order_id)
      end
    end

    # make sure there aren't duplicating orders
    @orders.uniq { |order| order.id }
  end

  # make this work for orders and order items?
  def separate_by_status(orders)
    @pending, @paid, @completed, @canceled = [], [], [], []

    orders.each do |order|
      case order.status
      when "pending"
        @pending << order
      when "paid"
        @paid << order
      when "completed"
        @completed << order
      when "canceled"
        @canceled << order
      end
    end
  end

  def revenue(order_items)
    # order_items is an array of ActiveRecord::Relation objects
    order_items.reduce(0) { |sum, n| sum + (n[0].product.price * n[0].quantity)}
  end
end
