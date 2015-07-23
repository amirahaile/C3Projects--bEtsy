class Product < ActiveRecord::Base
  attr_accessor :total_revenue

# Associations -----------------------------------------------------------------
  has_and_belongs_to_many :categories
  has_one :order_items
  belongs_to :user
  has_many :reviews

# Validations ------------------------------------------------------------------
  required_attributes = [ :name, :price, :photo_url, :inventory, :user_id ]
  required_attributes.each do |attribute|
    validates attribute, presence: true
  end

  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :inventory, numericality: { only_integer: true, greater_than: 0 }

# SCOPES -----------------------------------------------------------------------
  scope :by_vendor, -> (vendor) { where(user_id: vendor) }
  scope :by_category, -> (category) { joins(:categories).where("categories.id = ?", category) }

  def self.top_5(products)
    grouped_items = products.group_by { |product| product.id }
    popular_items = grouped_items.max_by(5) { |place, items| items.count }

    products = []
    popular_items.each do |item|
      # formatted [1, [<order>, <order>]]
      products << Product.find(item[1][0].id)
    end

    products
  end

# FAUX ATTRIBUTES --------------------------------------------------------------
  def total_revenue
    order_items = OrderItem.where(product_id: id).to_a
    total_sold = order_items.reduce(0) { |sum, n| sum + n.quantity }
    total_sold * price
  end
end
