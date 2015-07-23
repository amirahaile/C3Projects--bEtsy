class SessionsController < ApplicationController

  def self.sweep
    if session[:order_id] != nil

      delete_all "created_at < '#{1.day.ago.to_s(:db)}'"
    # else
      # session[:order_id] = nil
    end
  end

  def create # sign in
    @user = User.find_by(username: params[:session][:username])

    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:error] = "Incorrect username or password" # @user.errors.messages
      render :new
    end
  end

  def destroy # sign out
    reset_session
    redirect_to root_path
  end
end
