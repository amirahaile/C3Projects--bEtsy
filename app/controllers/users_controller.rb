class UsersController < ApplicationController
  before_action :find_user

  def show
    @user = User.find(params[:id])
    orders = Order.find_by(user_id: @user.id)
    separate_by_status(orders)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save

    redirect_to user_path(@user)
  end

  def edit
    # PLACE HOLDER - SHINY STUFF THAT ISN'T REQUIRED
  end

  def find_user
    current_user = User.find_by_id(session[:current_user_id])
  end

  private

  def user_params
    params.require(:review).permit(:username, :email, :password, :password_confirmation)
  end

  def separate_by_status(orders)
    @pending, @paid, @completed, @canceled = []

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
end
