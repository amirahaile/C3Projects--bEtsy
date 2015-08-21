require 'penguin_shipper_interface'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :logged_in

  # before_filter :update_session_time, :except => [:login, :logout]
  # before_filter :session_expires, :except => [:login, :logout]
  #
  # def update_session_time
  #  session[:expires_at] = 1.minutes.from_now
  # end
  # def session_expires
  #  @time_left = (session[:expires_at] - Time.now).to_i
  #  unless @time_left > 0
  #    reset_session
  #    flash[:error] = 'Lorem Ipsum.'
  #    redirect_to :controller => 'foo', :action => 'bar'
  #  end
  # end


  def require_login
    redirect_to new_user_path, flash: { error: "Merchant login required." } unless session[:user_id]
  end

  def logged_in
    @user = User.find_by(session[:user_id]) unless session[:user_id].nil?

    # guards from errors when order hasn't been initalized yet
    if session[:order_id] != nil
      @order = Order.find_by(session[:order_id])
      # @cart_quantity = quantity_in_cart(@order)
    # else
      # @cart_quantity = 0
    end
  end

  def view_active
    @products = Product.where(active: true)
  end

  private

  # def quantity_in_cart(order)
  #   order.order_items.reduce(0) { |sum, n| sum + n.quantity }
  # end
end
