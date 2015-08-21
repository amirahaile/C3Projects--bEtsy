FactoryGirl.define do

  factory :user do
    username "name"
    email "email@example.com"
    password "12345"
    password_digest "12345"
    country "US"
    state "OH"
    city "Dayton"
    zip "45459"
  end

  factory :countryless_user, class: User do
    username "name"
    email "email@example.com"
    password "12345"
    password_digest "12345"
    state "BC"
    city "Vancouver"
    zip "60652"
  end

  factory :product do
    name "taco costume"
    price 14.99
    photo_url "costume.jpg"
    inventory 5
    user_id 1
    weight 38.5
    height 3
    width 10.5
  end

  factory :order do
    email "email@example.com"
    address1 "123 Main St."
    status "pending"
    country "US"
    state "WA"
    city "Seattle"
    zipcode "98109"
    card_last_4 1234
    card_exp "10/17"
    shipping_price 10.99
    shipping_type "UPS 2Day"
    delivery_date "9/19/15"
    carrier "UPS"
    order_item_ids [1]
  end

  factory :countryless_order, class: Order do
    email "email@example.com"
    address1 "123 Main St."
    status "pending"
    state "BC"
    city "Vancouver"
    zipcode "60652"
    card_last_4 1234
    card_exp "10/17"
  end

  factory :order_item do
    quantity 1
    order_id 1
    product_id 1
  end
end
