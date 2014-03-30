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

ActiveRecord::Schema.define(version: 20140328101057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deliveries", force: true do |t|
    t.integer  "offer_id",    null: false
    t.integer  "location_id"
    t.datetime "when"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deliveries", ["location_id"], name: "index_deliveries_on_location_id", using: :btree
  add_index "deliveries", ["offer_id"], name: "index_deliveries_on_offer_id", using: :btree
  add_index "deliveries", ["when"], name: "index_deliveries_on_when", using: :btree

  create_table "group_offerings", force: true do |t|
    t.integer  "offer_id",   null: false
    t.integer  "group_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_offerings", ["offer_id", "group_id"], name: "index_group_offerings_on_offer_id_and_group_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["title"], name: "index_groups_on_title", unique: true, using: :btree

  create_table "locations", force: true do |t|
    t.string   "title",       null: false
    t.float    "lat"
    t.float    "lng"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["title"], name: "index_offers_on_title", unique: true, using: :btree

  create_table "offer_items", force: true do |t|
    t.integer  "offer_id",                                                      null: false
    t.integer  "position",                                      default: 0,     null: false
    t.string   "title",                                                         null: false
    t.text     "note"
    t.boolean  "placeholder",                                   default: false, null: false
    t.integer  "attachment_id"
    t.string   "status"
    t.datetime "status_changed_at"
    t.decimal  "total_available_qty",   precision: 7, scale: 1
    t.decimal  "min_qty_per_order",     precision: 7, scale: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "packaging"
    t.string   "packaging_description"
    t.string   "unit_bulk"
    t.integer  "price_bulk"
    t.string   "unit_package"
    t.integer  "price_package"
    t.string   "unit_vario"
    t.integer  "price_vario"
  end

  add_index "offer_items", ["offer_id"], name: "index_offer_items_on_offer_id", using: :btree
  add_index "offer_items", ["status"], name: "index_offer_items_on_status", using: :btree

  create_table "offers", force: true do |t|
    t.integer  "user_id",          null: false
    t.string   "title",            null: false
    t.text     "note"
    t.datetime "valid_from"
    t.datetime "valid_until"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "attach"
    t.string   "attach_mime_type"
    t.integer  "attach_file_size"
    t.string   "company_name"
    t.string   "company_address"
    t.string   "company_oib"
    t.string   "dispatch_place"
    t.string   "dispatch_date"
  end

  add_index "offers", ["user_id"], name: "index_offers_on_user_id", using: :btree

  create_table "order_items", force: true do |t|
    t.integer  "order_id",                                  null: false
    t.integer  "offer_item_id",                             null: false
    t.decimal  "qty",               precision: 7, scale: 1, null: false
    t.decimal  "min_qty",           precision: 7, scale: 1
    t.string   "status"
    t.datetime "status_changed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "corrected_qty",     precision: 7, scale: 1
    t.datetime "qty_corrected_at"
    t.string   "qty_description"
  end

  add_index "order_items", ["offer_item_id"], name: "index_order_items_on_offer_item_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["status"], name: "index_order_items_on_status", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "user_id",           null: false
    t.integer  "offer_id",          null: false
    t.integer  "delivery_id",       null: false
    t.text     "note"
    t.string   "status"
    t.datetime "status_changed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["delivery_id"], name: "index_orders_on_delivery_id", using: :btree
  add_index "orders", ["offer_id"], name: "index_orders_on_offer_id", using: :btree
  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree
  add_index "orders", ["user_id"], name: "index_ordes_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.integer  "group_id"
    t.string   "name",                                   null: false
    t.string   "phone",                                  null: false
    t.boolean  "admin",                  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_producer",            default: false
    t.text     "about_text"
    t.string   "about_url"
    t.string   "buyer_tag"
    t.integer  "requested_group_id"
    t.binary   "about_attach"
    t.string   "about_attach_mime_type"
    t.integer  "about_attach_file_size"
    t.string   "company_name"
    t.string   "company_address"
    t.string   "company_oib"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
