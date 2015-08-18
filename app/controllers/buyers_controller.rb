class BuyersController < ApplicationController
  include ApplicationHelper

  def new
    @buyer = Buyer.new
    @buyer.order_id = session[:order_id]
    if logged_in?
      @user = User.find(session[:user_id])
    end
  end

  def create
    @buyer = Buyer.new(buyer_params)
    if @buyer.save
      redirect_to shipping_info_path(@buyer.id)
    else
      render 'new'
    end
  end

  def edit # adds shipping info to @buyer
    # NOTE: Kind of screws you over if you wanted to add the functionality to edit a buyer's profile/info.
    @buyer = Buyer.find(params[:id])
    render :shipping_info
  end

  def update
    @buyer = Buyer.find(params[:id])
    shipping_info = buyer_params

    # The credit card is reduced to 4 digits after it's validated
    # during the first save of @buyer. Thus, we need to skip any
    # validations here, because they'd always fail the CC length.
    # NOTE: Should CC validation change to allow for shipping info to be validated?
    @buyer.shipping_address = shipping_info[:shipping_address]
    @buyer.shipping_city    = shipping_info[:shipping_city]
    @buyer.shipping_state   = shipping_info[:shipping_state]
    @buyer.shipping_zip     = shipping_info[:shipping_zip]
    @buyer.save(:validate => false)

    redirect_to shipping_quotes_path(@buyer.order_id)
  end

  def confirmation
    @order = Order.find(session[:order_id])
    transaction # application helper
  end

  private

    def buyer_params
      params.require(:buyer).permit(
        :name,
        :email,
        :billing_address,
        :billing_city,
        :billing_state,
        :billing_zip,
        :credit_card,
        :cvv,
        :exp,
        :order_id,
        :shipping_address,
        :shipping_city,
        :shipping_state,
        :shipping_zip
      )
    end
end
