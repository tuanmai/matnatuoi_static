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

ActiveRecord::Schema.define(version: 20160519155831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone_number"
    t.string   "note"
    t.string   "facebook_url"
    t.string   "price"
    t.string   "ship_time"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "district"
    t.string   "place_url"
    t.string   "skin_type"
    t.string   "allergy"
    t.string   "prefer"
    t.string   "combo"
    t.integer  "position"
    t.string   "photo_url"
    t.string   "facebook_id"
    t.string   "facebook_name"
  end

  create_table "facebook_messages", force: :cascade do |t|
    t.integer  "facebook_user_id"
    t.string   "timestamp"
    t.string   "facebook_mid"
    t.text     "message"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "facebook_users", force: :cascade do |t|
    t.string   "facebook_id"
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "customer_id"
    t.string   "address"
    t.string   "order_type"
    t.string   "week_id"
    t.boolean  "wait_for_address", default: false
    t.boolean  "ordered",          default: false
    t.text     "raw_data"
    t.string   "photo_url"
  end

  add_index "facebook_users", ["customer_id"], name: "index_facebook_users_on_customer_id", using: :btree

  create_table "google_configs", force: :cascade do |t|
    t.string "client_id"
    t.string "client_secret"
    t.string "refresh_token"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "num_of_weeks"
    t.boolean  "active",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders_weeks", id: false, force: :cascade do |t|
    t.integer "week_id"
    t.integer "order_id"
  end

  add_index "orders_weeks", ["order_id"], name: "index_orders_weeks_on_order_id", using: :btree
  add_index "orders_weeks", ["week_id"], name: "index_orders_weeks_on_week_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "sort_description"
    t.text     "description"
    t.string   "image_url"
    t.string   "product_url"
    t.string   "product_payload_code"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "week_id"
    t.text     "image"
  end

  add_index "products", ["week_id"], name: "index_products_on_week_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weeks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "status",      default: 0
    t.string   "order_label"
  end

end
