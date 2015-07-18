class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  # VALIDATIONS #
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
