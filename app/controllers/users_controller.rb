class UsersController < ApplicationController
  before_action :find_user

  def find_user
    current_user = User.find_by_id(session[:current_user_id])
  end

end
