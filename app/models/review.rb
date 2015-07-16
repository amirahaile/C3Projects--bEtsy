class Review < ActiveRecord::Base
  # Associations
  belongs_to :product

  # Validations
  validates :rating, presence: true, numericality: { only_integer: true },
                     format: { with: /[1-5]/ } # STILL WORKING ON
  validates :product_id, presence: true

  # Scopes
  # MAYBE DISPLAYING ON RATINGS BY 1, 2, 3, 4, OR 5.
end
