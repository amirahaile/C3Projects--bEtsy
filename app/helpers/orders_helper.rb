module OrdersHelper
  def order_error_check_for(element)
    if @order.nil?
      # NOTHING
    elsif @order.errors[element].any?
      return (@order.errors.messages[element][0].capitalize + ".")
    end
  end

  def shipping_option_label(shipping_option)
    %Q{#{shipping_option["service_name"]}: 
    #{display_dollars(shipping_option["total_price"])}, 
    Estimated delivery: 
    #{delivery_date(shipping_option["delivery_date"])}}
  end

  def delivery_date(date)
    if date
      readable_date(date.to_datetime)
    else
      "(none available)"
    end
  end

  def finalize_button
    @shipping_cost == 0 ? "btn btn-default disabled" : "btn btn-success"
  end

  def display_dollars(cents)
   number_to_currency(cents/100.00)
 end
end
