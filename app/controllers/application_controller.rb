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
  end
end
