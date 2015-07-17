class SessionsController < ApplicationController
  def new
  end

  def create # sign in
    @user = User.find_by(username: params[:session][:username])

    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:error] = "Incorrect username or password" # @user.errors.messages
      render 'new'
    end
  end

  def destroy # sign out
    session[:user_id] = nil
    redirect_to root_path
  end

end
