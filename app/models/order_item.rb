class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  # VALIDATIONS #
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
