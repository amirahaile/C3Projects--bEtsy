module OrdersHelper

  def item_total(order)
    items = OrderItem.where("order_id = ?", order.id).pluck(:quantity)
    @total_quantity = items.sum
  end

  # TODO: Pad with zeros!
  def usd_convert(cents)
    "$#{ cents / 100 }.#{ cents % 100 }"
  end
end
