class Product < ActiveRecord::Base
  # Associations ------------------
  has_and_belongs_to_many :categories
  has_many :order_items

  # Validations ------------------
  required_attributes = [ :name, :price, :photo_url, :inventory,
    :user_id ]
  required_attributes.each do |attribute|
    validates attribute, presence: true
  end

  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :inventory, numericality: { only_integer: true, greater_than: 0 }
  # need to add below once user is fleshed out?
  # validates_associated :user

end
