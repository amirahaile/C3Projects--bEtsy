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

  FEDAX_API_ROOT = "http://fedax.herokuapp.com"
  FEDAX_API_QUOTE_URL = FEDAX_API_ROOT + "/quote"
  FEDAX_API_SHIP_URL = FEDAX_API_ROOT + "/ship"
  FEDAX_API_DOWN_MESSAGE = "Shipping information is not available at this time. Please try again in a few minutes."


  def require_login
    redirect_to new_user_path, flash: { error: "Merchant login required." } unless session[:user_id]
  end

  def logged_in
    @user = User.find(session[:user_id]) unless session[:user_id].nil?
    # guards from errors when order hasn't been initalized yet
    reset_session
    if session[:order_id] != nil
      @order = Order.find(session[:order_id])
      @cart_quantity = quantity_in_cart(@order)
    else
      @cart_quantity = 0
    end
  end

  def view_active
    @products = Product.where(active: true)
  end

  private

  def quantity_in_cart(order)
    order.order_items.reduce(0) { |sum, n| sum + n.quantity }
  end

  def fed_ax_quote_request
    packages, origin, destination = prepare_request
    @order_items = @order.order_items

    begin
      response = Timeout::timeout(10) do
        HTTParty.get(
          FEDAX_API_QUOTE_URL,
          body: {
            packages: packages,
            origin: origin,
            destination: destination
          }
        )
      end
      # raise
      return response

    rescue Timeout::Error => error
      flash[:error] = FEDAX_API_DOWN_MESSAGE
      redirect_to :back and return
    end
  end

  def fed_ax_quote_update_request
    packages, origin, destination = prepare_request
    @order_items = @order.order_items

    begin
      response = Timeout::timeout(10) do
        HTTParty.get(
          FEDAX_API_QUOTE_URL,
          body: {
            packages: packages,
            origin: origin,
            destination: destination,
            shipping: prepare_shipping
          }
        )
      end
      return response

    rescue Timeout::Error => error
      flash[:error] = FEDAX_API_DOWN_MESSAGE
      redirect_to :back and return
    end
  end

  def fed_ax_ship_order_request
    packages, origin, destination = prepare_request
    @order_items = @order.order_items

    begin
      response = Timeout::timeout(10) do
        HTTParty.post(
          FEDAX_API_SHIP_URL,
          body: {
            packages: packages,
            origin: origin,
            destination: destination,
            shipping: prepare_shipping
          }
        )
      end

      return response

    rescue Timeout::Error => error
      flash[:error] = FEDAX_API_DOWN_MESSAGE + " We apologize for the inconvenience."
      redirect_to order_path(@order) and return
    end
  end

  def prepare_request
    @order_items = @order.order_items
    products = []
    @order_items.each { |item| products << Product.find_by(id: item.product_id) }

    packages = []
    origin = {}
    products.each_with_index do |product, index|
      packages <<
      {
        weight: product.weight,
        height: product.height,
        width: product.width,
        product_id: product.id
      }

      if index == 0 # we only need to set this once
        user = User.find_by(id: product.user_id)

        origin[:city] = user.city
        origin[:state] = user.state
        origin[:country] = user.country
        origin[:zip] = user.zip
      end
    end


    destination = {}
    destination[:country] = "US"
    destination[:state] = @order.state
    destination[:city] = @order.city
    destination[:zip] = @order.zipcode
    destination[:order_id] = @order.id

    return packages, origin, destination
  end

  def prepare_shipping
    return { carrier: @order.carrier, service_type: @order.shipping_type }
  end
end
