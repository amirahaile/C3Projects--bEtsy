class Review < ActiveRecord::Base
  # Associations
  belongs_to :product

  # Validations
  validates :rating, presence: true, numericality: { only_integer: true },
                     format: { with: /[1-5]/ } # STILL WORKING ON
  validates :product_id, presence: true

  # Scopes
  # NEED TO TEST:
  # scope :ratings_by_1, -> { where(rating: 1) }
  # scope :ratings_by_2, -> { where(rating: 2) }
  # scope :ratings_by_3, -> { where(rating: 3) }
  # scope :ratings_by_4, -> { where(rating: 4) }
  # scope :ratings_by_5, -> { where(rating: 5) }

  # MAYBE DISPLAYING ON RATINGS BY 1, 2, 3, 4, OR 5.
end
