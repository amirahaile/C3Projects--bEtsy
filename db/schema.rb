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

ActiveRecord::Schema.define(version: 20150820001642) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "quantity",   default: 1, null: false
    t.integer  "order_id",               null: false
    t.integer  "product_id",             null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "card_number"
    t.string   "card_last_4"
    t.datetime "card_exp"
    t.string   "status",      default: "pending", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "ccv"
    t.string   "name",        default: "guest",   null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",                                                 null: false
    t.string   "description"
    t.decimal  "price",         precision: 7, scale: 2,                null: false
    t.string   "photo_url",                                            null: false
    t.integer  "inventory",                                            null: false
    t.boolean  "active",                                default: true, null: false
    t.integer  "user_id",                                              null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "weight_in_gms"
    t.decimal  "length_in_cms", precision: 6, scale: 1
    t.decimal  "width_in_cms",  precision: 6, scale: 1
    t.decimal  "height_in_cms", precision: 6, scale: 1
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating",      null: false
    t.string   "description"
    t.integer  "product_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",        null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "country"
  end

end
