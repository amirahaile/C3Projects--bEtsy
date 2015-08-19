class Buyer < ActiveRecord::Base
  belongs_to :order

  # CALLBACK
  after_validation :convert_to_last_four

  # VALIDATIONS ----------------------------------------------------------
  validates :name,                presence: true
  validates :email,               presence: true, format: /@/
  validates :billing_address,     presence: true
  validates :billing_zip,         presence: true,
                                  numericality: { only_integer: true },
                                  length: { in: 4..5}
  validates :billing_state,       presence: true,
                                  length: { is: 2 }
  validates :billing_city,        presence: true
  validates :exp,                 presence: true
  validates :credit_card,         presence: true,
                                  numericality: { only_integer: true },
                                  length: { in: 14..16 }


  def for_shipping
    buyer = self
    json = {
      state: buyer[:shipping_state],
      city: buyer[:shipping_city],
      zip: buyer[:shipping_zip]
    }
  end
  
  private

  def convert_to_last_four
    array = self.credit_card.to_s.split("")
    return self.credit_card unless array.length >= 4
    last_four = array[-4..-1].join.to_i
    self.credit_card = last_four
  end
end
