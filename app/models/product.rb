class Product < ActiveRecord::Base
  # Associations ------------------
  has_and_belongs_to_many :categories
  has_one :order_items
  belongs_to :user
  has_many :reviews

  # Validations ------------------
  required_attributes = [ :name, :price, :photo_url, :inventory,
    :user_id ]
  required_attributes.each do |attribute|
    validates attribute, presence: true
  end

  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :inventory, numericality: { only_integer: true, greater_than: 0 }

  scope :by_vendor, -> (vendor) { where(user_id: vendor) }
  scope :by_category, -> (category) { joins(:categories).where("categories.id = ?", category) }

end
