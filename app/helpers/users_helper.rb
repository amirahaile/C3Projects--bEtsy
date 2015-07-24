module UsersHelper
  def error_check_for(element)
    if @user.errors[element].any?
      return (@user.errors.messages[element][0].capitalize + ".")
    end
  end
end
