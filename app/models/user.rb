class User < ActiveRecord::Base
# Associations -----------------------------------------------------------------
  has_secure_password
  has_many :products

# Validations ------------------------------------------------------------------
  FIVE_DIGIT_STRING_REGEX = /\A\d{5}\z/

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i #, on: :create
  validates :password, presence: true, confirmation: true
  validates :country, :state, :city, :zip, presence: true
  validates_format_of :zip, with: FIVE_DIGIT_STRING_REGEX

# Scopes -----------------------------------------------------------------------
  def self.product_ids_from_user(user)
    user_products = user.products.to_a

    product_ids = []
    user_products.each do |product|
      product_ids << product.id
    end

    product_ids
  end

  def self.order_items_from_products(product_ids)
    order_items = []
    product_ids.each do |product_id|
      order_items << OrderItem.where(product_id: product_id).to_a
    end

    return [] if order_items.nil?
    order_items.flatten!
  end

  def self.orders_from_order_items(order_items)
    orders = []
    if order_items.nil?
      return orders
    else
      order_items.each do |item|
        orders << Order.find(item.order_id)
      end
    end

    # make sure there aren't duplicating orders
    orders.uniq { |order| order.id }
  end

  def self.orders_items_from_order(orders_by_status, user)
    unless orders_by_status.empty?
      order_items = []
      orders_by_status.each do |order|
        order_items << OrderItem.where(order_id: order.id).to_a
      end

      order_items_array = []
      order_items.each do |order_item|
        if order_item.first.product.user.id == user.id
          order_items_array << order_item
        end
        order_items_array.flatten!
      end
        return order_items_array

      # order_items.flatten.reject! { |item| item.product.user.id != user.id }
    else
      nil
    end
  end
end
