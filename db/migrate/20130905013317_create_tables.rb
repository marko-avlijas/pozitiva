class CreateTables < ActiveRecord::Migration
  def change

    create_table "locations", :force => true do |t|
      t.string   "title",       null: false
      t.float    "lat"
      t.float    "lng"
      t.string   "description"
      t.timestamps
    end
    add_index "locations", ["title"], :name => "index_offers_on_title", unique: true
    
    create_table "offers", :force => true do |t|
      t.integer  "user_id",     null: false
      t.string   "title",       null: false
      t.text     "note"
      t.datetime "valid_from"
      t.datetime "valid_until"
      t.timestamps
    end
    add_index "offers", ["user_id"], :name => "index_offers_on_user_id"

    create_table "deliveries", :force => true do |t|
      t.integer  "offer_id",    null: false
      t.integer  "location_id"
      t.datetime "when"
      t.timestamps
    end
    add_index "deliveries", ["offer_id"], :name => "index_deliveries_on_offer_id"
    add_index "deliveries", ["location_id"], :name => "index_deliveries_on_location_id"
    add_index "deliveries", ["when"], :name => "index_deliveries_on_when"
    
    create_table "offer_items", :force => true do |t|
      t.integer  "offer_id", null: false
      t.integer  "position", default: 0, null: false
      t.string   "title", null: false
      t.string   "unit"
      t.integer  "price", default: 0, null: false # 2 decimal converversion with virtual attribute decimal_price
      t.text     "note"
      t.boolean  "placeholder", default: false, null: false
      t.integer  "attachment_id"
      t.string   "status"
      t.datetime "status_changed_at"
      t.boolean  "is_package",          default: false, null: false
      t.decimal  "total_available_qty",     precision: 7, scale: 1
      t.decimal  "min_qty_per_order",       precision: 7, scale: 1
      t.timestamps
    end
    add_index "offer_items", ["status"], :name => "index_offer_items_on_status"
    add_index "offer_items", ["offer_id"], :name => "index_offer_items_on_offer_id"    
  
    create_table "orders", :force => true do |t|
      t.integer  "user_id",      null: false
      t.integer  "offer_id",     null: false
      t.integer  "delivery_id",  null: false
      t.text     "note"
      t.string   "status"
      t.datetime "status_changed_at"
      t.timestamps
    end
    add_index "orders", ["status"], :name => "index_orders_on_status"
    add_index "orders", ["user_id"], :name => "index_ordes_on_user_id"
    add_index "orders", ["offer_id"], :name => "index_orders_on_offer_id"
    add_index "orders", ["delivery_id"], :name => "index_orders_on_delivery_id"
  
    create_table "order_items", :force => true do |t|
      t.integer  "order_id",           null: false
      t.integer  "offer_item_id",      null: false
      t.decimal  "qty",                null: false, precision: 7, scale: 1
      t.decimal  "min_qty",            precision: 7, scale: 1
      t.decimal  "solidary_qty",       precision: 7, scale: 1
      t.datetime "solidary_qty_changed_at"
      t.string   "status"
      t.datetime "status_changed_at"
      t.timestamps
    end
    add_index "order_items", ["status"], :name => "index_order_items_on_status"
    add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
    add_index "order_items", ["offer_item_id"], :name => "index_order_items_on_offer_item_id"
  
    create_table "groups", :force => true do |t|
      t.string  "title",           null: false
      t.timestamps
    end
    add_index :groups, :title, unique: true

    create_table "group_offerings", :force => true do |t|
      t.integer  "offer_id",    null: false
      t.integer  "group_id",    null: false
      t.timestamps
    end
    add_index "group_offerings", ["offer_id", "group_id"]

  end
end
