class Product < ActiveRecord::Base
# VALIDATIONS ------------------------------------------------------------------

 validates :name, presence: true, uniqueness: true
 validates :price, presence: true, numericality: { greater_than: 0 }
 validates :user_id, presence: true
 validates :stock, numericality: {greater_than_or_equal_to: 0}
 validates :weight, :height, :length, :width, presence: true, length: { maximum: 4 }

# ASSOCIATIONS -----------------------------------------------------------------

  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories#, reject_if: proc {|attributes| attributes['name'].blank? }
  belongs_to :user
  has_many :reviews
  has_many :order_items

# SCOPE ------------------------------------------------------------------------

  scope :active_product, -> { where(retired: false) }

  def retire_toggle!
    self.retired ? self.retired = false : self.retired = true
  end
end
