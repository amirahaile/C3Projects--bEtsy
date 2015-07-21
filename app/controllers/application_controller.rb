class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :logged_in

  def require_login
    redirect_to login_path, flash: { error: "Merchant login required" } unless session[:user_id]
  end

  def logged_in
    @user = User.find(session[:user_id]) unless session[:user_id].nil?
    @username = @user ? @user.username : "Guest"

    # guards from errors when order hasn't been initalized yet
    if session[:order_id] != nil
      @order = Order.find(session[:order_id])
      @cart_quantity = quantity_in_cart(@order)
    end
  end

  private

  def quantity_in_cart(order)
    order.order_items.reduce(0) { |sum, n| sum + n.quantity }
  end
end
