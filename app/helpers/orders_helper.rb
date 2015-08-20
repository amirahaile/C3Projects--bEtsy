module OrdersHelper
  def order_error_check_for(element)
    if @order.nil?
      # NOTHING
    elsif @order.errors[element].any?
      return (@order.errors.messages[element][0].capitalize + ".")
    end
  end

  def shipping_option_label(shipping_option)
    "#{shipping_option["service_name"]}: $#{shipping_option["total_price"]/100.0}, Estimated delivery: #{shipping_option["delivery_date"] || "(none available)"}"
  end

  def finalize_button
    @shipping_cost == 0 ? "btn btn-default disabled" : "btn btn-success"
  end
end
