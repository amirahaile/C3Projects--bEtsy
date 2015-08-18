class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  has_many :products
  has_many :order_items, :through => :products
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: /@/
  validates :address, :city, :state, :zip, presence: true
  has_secure_password
end
