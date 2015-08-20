FactoryGirl.define do
  factory :category do
    name "Hats"
  end

  factory :order_item do
    quantity 1
    order_id 1
    product_id 1
  end

  factory :order do
    email "somedude@someplace.com"
    address "1111 Someplace Ave."
    city "San Leandro"
    state "CA"
    zip 94578
    card_last_4 "1234"
    card_exp Time.new(2017, 11)
  end

  factory :product do
    name "A product"
    price 20.95
    photo_url "a_photo.jpg"
    inventory 4
    user_id 1
    weight_in_gms 100
    length_in_cms 15
    width_in_cms 10
    height_in_cms 10
  end

  factory :review do
    rating 5
    product_id 1
  end

  factory :user do
    username "aname"
    email "hi@email.com"
    password "password"
    password_confirmation "password"
    city "Seattle"
    state "WA"
    zip 98101
    country "US"
  end
end
