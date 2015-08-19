FactoryGirl.define do
  factory :buyer do
    name "new buyer"
    email "buyer@email.com"
    billing_address "1352 Front Street"
    billing_city "Mahopac"
    billing_state "NY"
    billing_zip "10541"
    shipping_address "1352 Front Street"
    shipping_city "Mahopac"
    shipping_state "NY"
    shipping_zip "10541"
    exp "exp"
    credit_card 12345678901234
  end
end
