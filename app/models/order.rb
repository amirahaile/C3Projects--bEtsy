class Order < ActiveRecord::Base
  # Associations
  has_many :order_items

  # Validations
  validates :email, presence: true
  validates :address1, presence: true
  validates :city, presence: true
  validates :state, presence: true, length: { is: 2 } #, must be two (capital) characters? ex. WA
  validates :zipcode, presence: true #, must be five-ten characters? ex. 55555-5555
  validates :card_last_4, presence: true, length: { is: 4 }
  validates :card_exp, presence: true #, must be in the future?
  validates :status, presence: true, inclusion:
                                     { in: %w(pending paid cancelled complete),
                                       message: "%{value} is not a valid status" }

  # Callbacks
  before_validation :capitalize_city!, :state_conversion!

  def capitalize_city!
    return unless self.city == city.capitalize

    self.city.capitalize!
  end

  states = {
    "AL" => "Alabama"
    "AK" => "Alaska"
    "AZ" => "Arizona"
    "AR" => "Arkansas"
    "CA" => "California"
    "CO" => "Colorado"
    "CT" => "Connecticut"
    "DE" => "Delaware"
    "FL" => "Florida"
    "GA" => "Georgia"
    "HI" => "Hawaii"
    "ID" => "Idaho"
    "IL" => "Illinois"
    "IN" => "Indiana"
    "IA" => "Iowa"
    "KS" => "Kansas"
    "KY" => "Kentucky"
    "LA" => "Louisiana"
    "ME" => "Maine"
    "MD" => "Maryland"
    "MA" => "Massachusetts"
    "MI" => "Michigan"
    "MN" => "Minnesota"
    "MS" => "Mississippi"
    "MO" => "Missouri"
    "MT" => "Montana"
    "NE" => "Nebraska"
    "NV" => "Nevada"
    "NH" => "New Hampshire"
    "NJ" => "New Jersey"
    "NM" => "New Mexico"
    "NY" => "New York"
    "NC" => "North Carolina"
    "ND" => "North Dakota"
    "OH" => "Ohio"
    "OK" => "Oklahoma"
    "OR" => "Oregon"
    "PA" => "Pennsylvania"
    "RI" => "Rhode Island"
    "SC" => "South Carolina"
    "SD" => "South Dakota"
    "TN" => "Tennessee"
    "TX" => "Texas"
    "UT" => "Utah"
    "VT" => "Vermont"
    "VA" => "Virginia"
    "WA" => "Washington"
    "WV" => "West Virginia"
    "WI" => "Wisconsin"
    "WY" => "Wyoming"
  }

  def state_conversion!
    return if self.state.states.keys.includes?(self.state)

    # STUFF GOES HERE
  end
end
