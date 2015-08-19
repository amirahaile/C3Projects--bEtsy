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
    password_confirmation: "extraCheese",
    country: "US",
    state: "WA",
    city: "Seattle",
    zip: "98109" },
  { username: "indubitably",
    email: "johnsnow@tennisrocks.uk",
    password: "aaronwilliams",
    password_confirmation: "aaronwilliams",
    country: "US",
    state: "WA",
    city: "Seattle",
    zip: "98109" },
  { username: "mabel",
    email: "mabel@awesomedogs.woof",
    password: "growl",
    password_confirmation: "growl",
    country: "US",
    state: "WA",
    city: "Seattle",
    zip: "98109" },
]

users.each do |user|
  User.create(user)
end

categories = [
  { name: "Pet" }, { name: "Adult" }, { name: "Child" }
]

categories.each do |category|
  Category.create(category)
end

products = [
  { name: "Taco Costume",
    description: "High-quality, one-size-fits-all adult hard-shelled taco costume (beef).",
    price: 10.00,
    photo_url: "adult_taco.jpeg",
    inventory: 45,
    active: true,
    user_id: 1,
    category_ids: 2,
    weight: 38.0,
    height: 0.25,
    width: 0.85,
    depth: 5 },
  { name: "Mr. T Costume for Dog",
    description: "Your dog will pity the fool with this totally awesome costume!",
    price: 25.00,
    photo_url: "pity-the-fool-dog.jpeg",
    inventory: 58,
    active: true,
    user_id: 2,
    category_ids: [1, 3],
    weight: 38.0,
    height: 0.25,
    width: 0.85,
    depth: 5 },
  { name: "Mr. T Costume for Dog - Large",
    description: "Your dog will pity the fool with this totally awesome costume!",
    price: 35.00,
    photo_url: "pity-the-fool-dog.jpeg",
    inventory: 2,
    active: true,
    user_id: 1,
    category_ids: [1, 3],
    weight: 38.0,
    height: 0.25,
    width: 0.85,
    depth: 5 },
  { name: "Taco Costume - Large",
    description: "High-quality, one-size-fits-all adult hard-shelled taco costume (beef).",
    price: 40.00,
    photo_url: "adult_taco.jpeg",
    inventory: 4,
    active: true,
    user_id: 2,
    category_ids: 2,
    weight: 38.0,
    height: 0.25,
    width: 0.85,
    depth: 5 },
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
    status: "paid",
    country: "US" },
  { email: "starbuck@galactica.com",
    address1: "123 New Caprica St.",
    address2: "Shack #2",
    city: "Caprica",
    state: "NC",
    zipcode: 77777,
    card_last_4: 7777,
    card_exp: Time.new(2019, 9),
    status: "pending",
    country: "US" },
]

orders.each do |order|
  Order.create(order)
end

# order = Order.new(id: 6)
# order.save(validate: false)
