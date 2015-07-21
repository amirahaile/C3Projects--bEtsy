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

    # let the model check if it successfuly passes validations and saves
      # if not, send a flash error depedning on what errors are thrown?
    if @user.save
      session[:user_id] = @user.id # creates a session - they are logged in
      redirect_to user_path(@user) # WHERE DO WE WANT THIS TO REDIRECT TO?
      # redirect_to root_path # with a message that they successfully created an account
    else
      flash.now[:errors] = "ERROR"
        # Would we use the flash.now to display the individual errors.
        # Would we reference the individual errors via the insance variable?
          # long_message = ""
          # count = 0
          # while (@user.errors.messages[:password].count - 1)

          # @user.errors.messages[:password].each do |message|
          #   long_message = message + "&"
          # end
      # raise
      render :new
    end

  end

  def edit
    # PLACE HOLDER - SHINY STUFF THAT ISN'T REQUIRED
  end

  def find_user
    current_user = User.find_by_id(session[:current_user_id])
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
