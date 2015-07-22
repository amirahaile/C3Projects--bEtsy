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

  def revenue(order_items)
    order_items.reduce(0) { |sum, n| sum + (n.product.price * n.quantity)}
  end
end
