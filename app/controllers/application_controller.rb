class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :logged_in

  def require_login
    redirect_to login_path, flash: { error: "Merchant login required" } unless session[:user_id]
  end

  # on Products#index the cart badge goes back to 0
  def logged_in
    @user = User.find(session[:user_id]) unless session[:user_id].nil?
    @username = @user ? @user.username : "Guest"
    @order = Order.find(session[:order_id])
    @order_items = @order.order_items
  end
end
