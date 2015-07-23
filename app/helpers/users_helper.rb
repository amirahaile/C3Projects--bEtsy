module UsersHelper
  def error_check_for(element)
    if @user.errors[element.to_sym].any?
      return (@user.errors.messages[element.to_sym][0].capitalize + ".")
    end
  end
end
