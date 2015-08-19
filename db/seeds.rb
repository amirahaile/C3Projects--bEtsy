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
    city: "Seattle",
    state: "WA",
    zip: 98101,
    country: "US" },
  { username: "indubitably",
    email: "johnsnow@tennisrocks.uk",
    password: "aaronwilliams",
    password_confirmation: "aaronwilliams",
    city: "South San Francisco",
    state: "CA",
    zip: 94080,
    country: "US" },
  { username: "mabel",
    email: "mabel@awesomedogs.woof",
    password: "growl",
    password_confirmation: "growl",
    city: "Chicago",
    state: "IL",
    zip: 60614,
    country: "US" },
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
    weight_in_gms: 1500,
    length_in_cms: 30,
    width_in_cms: 10,
    height_in_cms: 5 },
  { name: "Mr. T Costume for Dog",
    description: "Your dog will pity the fool with this totally awesome costume!",
    price: 25.00,
    photo_url: "pity-the-fool-dog.jpeg",
    inventory: 58,
    active: true,
    user_id: 2,
    category_ids: [1, 3],
    weight_in_gms: 500,
    length_in_cms: 15,
    width_in_cms: 8,
    height_in_cms: 2 },
  { name: "Mr. T Costume for Dog - Large",
    description: "Your dog will pity the fool with this totally awesome costume!",
    price: 35.00,
    photo_url: "pity-the-fool-dog.jpeg",
    inventory: 2,
    active: true,
    user_id: 1,
    category_ids: [1, 3], 
    weight_in_gms: 1000,
    length_in_cms: 20,
    width_in_cms: 8,
    height_in_cms: 3 },
  { name: "Taco Costume - Large",
    description: "High-quality, one-size-fits-all adult hard-shelled taco costume (beef).",
    price: 40.00,
    photo_url: "adult_taco.jpeg",
    inventory: 4,
    active: true,
    user_id: 2,
    category_ids: 2, 
    weight_in_gms: 1700,
    length_in_cms: 30,
    width_in_cms: 10,
    height_in_cms: 7 },
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

order = Order.new(id: 6)
order.save(validate: false)
