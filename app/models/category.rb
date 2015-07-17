class Category < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :products

  # Validations
  validates :name, presence: true, uniqueness: true
end
