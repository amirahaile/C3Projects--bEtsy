class Review < ActiveRecord::Base
  # Associations
  belongs_to :product

  # Validations
  validates :rating, presence: true, numericality: { only_integer: true },
                    inclusion: { in: [1, 2, 3, 4, 5] }
  validates :product_id, presence: true, numericality: { only_integer: true }

  # Scopes
  scope :ratings_by_1, -> { where(rating: 1) }
  scope :ratings_by_2, -> { where(rating: 2) }
  scope :ratings_by_3, -> { where(rating: 3) }
  scope :ratings_by_4, -> { where(rating: 4) }
  scope :ratings_by_5, -> { where(rating: 5) }

  def self.average_rating(product_id)
    all_reviews = where(product_id: product_id)
    review_count = all_reviews.count
    sum = 0
    all_reviews.each { |review| sum += review.rating }
    review_count != 0 ? (sum / review_count) : 0
  end

  # Callbacks
  before_validation :integerize_rating!, only: [:rating]

  def integerize_rating!
    return if self.rating == rating.to_i

    self.rating = self.rating.to_i
  end # How could you use this for both rating & product_id? - Brandi
      # It seems like I have to specify self.SOME-METHOD....
end
