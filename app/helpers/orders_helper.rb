module OrdersHelper
  def order_error_check_for(element)
    if @order.nil?
      # NOTHING
    elsif @order.errors[element].any?
      return (@order.errors.messages[element][0].capitalize + ".")
    end
  end

  def pretty_date(datetime)
    Date.parse(datetime).strftime("%A %B %d, %Y")
  end

end
