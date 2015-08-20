class Order < ActiveRecord::Base
# Associations -----------------------------------------------------------------
  has_many :order_items

# Validations ------------------------------------------------------------------
  validates_presence_of :email, :address1, :city, :state, :zip,
                        :card_last_4, :card_exp, :status
  validates :email, presence: true
    # you don't want a email address to be unique here because then the same person couldn't order twice from your website - Brandi
  validates_format_of :email, with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\Z/i
  validates_length_of :state, is: 2, message: "must be state abbreviation" # must be two (capital) characters? ex. WA
  validates_length_of :card_last_4, is: 4
  validates_length_of :zip, within: 5..10
  validates_format_of :card_last_4, with: /[0-9]{4}/, message: "only numbers allowed"
  validates_inclusion_of :status, in: %w(pending paid cancelled complete),
                                  message: "%{value} is not a valid status"

# Scopes -----------------------------------------------------------------------
  def self.by_status(orders, status_string)
    orders = orders.map { |order| order if order.status == status_string }
    # map returns nil if the order doesn't match
    orders.reject { |order| order == nil }
  end

  def self.latest_5(orders)
    orders.max_by(5) { |order| order.created_at }
  end

# Callbacks --------------------------------------------------------------------
  # before_validation :capitalize_city!, only: [:city]
  # before_validation :state_conversion!, only: [:state]
  #
  # def capitalize_city!
  #   return if self.city == nil
  #   return unless self.city == city.capitalize
  #
  #   self.city.capitalize!
  # end
  #
  # def state_conversion!
  #   states = {
  #     "AL" => "Alabama",
  #     "AK" => "Alaska",
  #     "AZ" => "Arizona",
  #     "AR" => "Arkansas",
  #     "CA" => "California",
  #     "CO" => "Colorado",
  #     "CT" => "Connecticut",
  #     "DE" => "Delaware",
  #     "FL" => "Florida",
  #     "GA" => "Georgia",
  #     "HI" => "Hawaii",
  #     "ID" => "Idaho",
  #     "IL" => "Illinois",
  #     "IN" => "Indiana",
  #     "IA" => "Iowa",
  #     "KS" => "Kansas",
  #     "KY" => "Kentucky",
  #     "LA" => "Louisiana",
  #     "ME" => "Maine",
  #     "MD" => "Maryland",
  #     "MA" => "Massachusetts",
  #     "MI" => "Michigan",
  #     "MN" => "Minnesota",
  #     "MS" => "Mississippi",
  #     "MO" => "Missouri",
  #     "MT" => "Montana",
  #     "NE" => "Nebraska",
  #     "NV" => "Nevada",
  #     "NH" => "New Hampshire",
  #     "NJ" => "New Jersey",
  #     "NM" => "New Mexico",
  #     "NY" => "New York",
  #     "NC" => "North Carolina",
  #     "ND" => "North Dakota",
  #     "OH" => "Ohio",
  #     "OK" => "Oklahoma",
  #     "OR" => "Oregon",
  #     "PA" => "Pennsylvania",
  #     "RI" => "Rhode Island",
  #     "SC" => "South Carolina",
  #     "SD" => "South Dakota",
  #     "TN" => "Tennessee",
  #     "TX" => "Texas",
  #     "UT" => "Utah",
  #     "VT" => "Vermont",
  #     "VA" => "Virginia",
  #     "WA" => "Washington",
  #     "WV" => "West Virginia",
  #     "WI" => "Wisconsin",
  #     "WY" => "Wyoming"
  #   }
  #   return if self.state == nil
  #   return if states.keys.includes?(self.state)
  #
  #   if states.values.includes?(self.state)
  #     self.state = states.find { |abbr, full| full == self.state }[0]
  #   else
  #     return
  #     # RETURN AN ERROR?
  #   end
  # end
end
