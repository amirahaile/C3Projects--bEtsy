FactoryGirl.define do
  factory :user do
    name "Frank"
    email "name@email.com"
    password "fr@nklin"
    password_confirmation "fr@nklin"
    address "2364 Route 9"
    city "Pomona"
    state "CA"
    zip "91768"
  end
end
