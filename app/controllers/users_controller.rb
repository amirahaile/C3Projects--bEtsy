class UsersController < ApplicationController
  before_action :find_user, only: [:show, :correct_user]
  before_action :correct_user, except: [:new, :create]
  # need this so it can see the helper methods
  include ApplicationHelper

  def show
    @products = @user.products
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  private

    def user_params
      params.require(:user).permit(
        :name,
        :address,
        :city,
        :state,
        :zip,
        :email,
        :password,
        :password_confirmation
      )
    end

    def find_user
      @user = User.find(params[:id])
    end
end
