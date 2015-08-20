class Category < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :products

  # Validations
  validates :name, presence: true, uniqueness: true

  # Callbacks
  before_validation :normalize_names!

  def normalize_names!
    self.name = self.name.titlecase unless name == nil
  end
end
