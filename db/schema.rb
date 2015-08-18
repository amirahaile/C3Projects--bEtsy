# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150818205938) do

  create_table "buyers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "billing_address"
    t.string   "billing_city"
    t.string   "billing_state"
    t.integer  "billing_zip"
    t.integer  "credit_card",      limit: 8
    t.integer  "cvv"
    t.string   "exp"
    t.integer  "order_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "shipping_address"
    t.string   "shipping_city"
    t.string   "shipping_state"
    t.integer  "shipping_zip"
  end

  add_index "buyers", ["order_id"], name: "index_buyers_on_order_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  add_index "categories_products", ["category_id"], name: "index_categories_products_on_category_id"
  add_index "categories_products", ["product_id"], name: "index_categories_products_on_product_id"

  create_table "order_items", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "unit_price"
    t.float    "total_price"
    t.string   "status"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"
  add_index "order_items", ["product_id"], name: "index_order_items_on_product_id"

  create_table "orders", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "subtotal"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.float    "price"
    t.text     "desc"
    t.integer  "stock"
    t.string   "photo_url"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "retired",    default: false
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "reviews", force: :cascade do |t|
    t.text     "body"
    t.integer  "rating"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reviews", ["product_id"], name: "index_reviews_on_product_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
