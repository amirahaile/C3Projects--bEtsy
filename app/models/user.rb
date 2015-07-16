class User < ActiveRecord::Base
  has_secure_password
  has_many :products
# Validations --------------------------------
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i #, on: :create
  validates :password, presence: true, confirmation: true
  # Password Confirmation must match Password
end
