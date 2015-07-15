# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

reviews = [
  { rating: 2,
    description: "This product is LAME",
    product_id: 1 },
  { rating: 5,
    description: "This product is THE. BEST.",
    product_id: 2 },
  { rating: 4,
    description: "This product is not actually lame after all.",
    product_id: 1 },
]

reviews.each do |review|
  Review.create(review)
end

users = [
  { username: "tacoparty",
    email: "taco@party.taco",
    password: "extraCheese",
    password_confirmation: "extraCheese" },
  { username: "indubitably",
    email: "johnsnow@tennisrocks.uk",
    password: "aaronwilliams",
    password_confirmation: "aaronwilliams" },
  { username: "mabel",
    email: "mabel@awesomedogs.woof",
    password: "growl",
    password_confirmation: "growl" },
]

users.each do |user|
  User.create(user)
end

order_items = [
  { quantity: 234,
    order_id: 1,
    product_id: 2 },
  { quantity: 77,
    order_id: 2,
    product_id: 1 },
]

order_items.each do |item|
  OrderItem.create(item)
end

products = [
  { name: "Taco Costume",
    description: "High-quality, one-size-fits-all adult hard-shelled taco costume (beef).",
    price: 1000,
    photo_url: "/images/adult_taco.jpeg",
    inventory: 45,
    active: true,
    user_id: "tacoparty"},
  { name: "Mr. T Costume for Dog",
    description: "Your dog will pity the fool with this totally awesome costume!",
    price: 2500,
    photo_url: "/images/adult_taco.jpeg",
    inventory: 58,
    active: true,
    user_id: "indubitably"}
]

products.each do |product|
  Product.create(product)
end

orders = [
  { email: "pluto@planet.com",
    address1: "Really, really far away",
    address2: "Outer reaches of the solar system",
    city: "Plutotown",
    state: "PA",
    zipcode: 99999,
    card_last_4: 9999,
    card_exp: Time.new(2018, 8),
    status: "paid"},
  { email: "starbuck@galactica.com",
    address1: "123 New Caprica St.",
    address2: "Shack #2",
    city: "Caprica",
    state: "NC",
    zipcode: 77777,
    card_last_4: 7777,
    card_exp: Time.new(2019, 9),
    status: "pending"},
]

orders.each do |order|
  Order.create(order)
end

categories = [
  { name: "Pet" }, { name: "Adult" }, { name: "Child" }
]

categories.each do |category|
  Category.create(category)
end
