class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }

# Associations -----------------------------------------------------------------
  has_many :products
  has_many :order_items, :through => :products

# Validations ------------------------------------------------------------------
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: /@/
  validates :address, :city, :state, :zip, presence: true

# Methods ----------------------------------------------------------------------
  def for_shipping
    user = self
    json = {
      state: user[:state],
      city: user[:city],
      zip: user[:zip]
    }
  end
end
