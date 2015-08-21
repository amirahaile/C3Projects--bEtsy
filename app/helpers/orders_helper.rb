module OrdersHelper

  def item_total(order)
    items = OrderItem.where("order_id = ?", order.id).pluck(:quantity)
    @total_quantity = items.sum
  end

  # TODO: Pad with zeros!
  def usd_convert(cents)
    dollars = cents / 100
    cents = (cents % 100).to_s

    while cents.length < 2
      cents += "0"
    end

    "$#{ dollars }.#{ cents }"
  end
end
