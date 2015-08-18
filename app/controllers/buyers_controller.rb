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
      redirect_to buyer_confirmation_path(@buyer.order_id)
    else
      render 'new'
    end
  end

  def confirmation
    @order = Order.find(session[:order_id])
    transaction # application helper
  end

  private

    def buyer_params
      params.require(:buyer).permit(:name, :email, :address, :city, :state, :zip, :credit_card, :cvv, :exp, :order_id)
    end
end
