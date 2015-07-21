class UsersController < ApplicationController
  before_action :find_user

  def index
    # PLACEHOLDER
    # NEEDS A WAY TO FIND RETURN USER ACCORDING TO SESSION
    # OR MAKE A DIFFERENT ACTION FOR DASHBOARD THAT TAKES AN ID
  end

  def show
    @user = User.find(params[:id])
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

end
