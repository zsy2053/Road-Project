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

ActiveRecord::Schema.define(version: 20180114233639) do

  create_table "accesses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_accesses_on_contract_id"
    t.index ["user_id"], name: "index_accesses_on_user_id"
  end

  create_table "contracts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "site_id"
    t.string "status", default: "draft", null: false
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_contracts_on_site_id"
  end

  create_table "definitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "road_order_id"
    t.string "work_location"
    t.string "day"
    t.string "shift"
    t.string "sequence_number"
    t.string "name"
    t.text "description"
    t.integer "expected_duration"
    t.integer "breaks"
    t.time "expected_start"
    t.time "expected_end"
    t.boolean "serialized"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "positions"
    t.index ["road_order_id"], name: "index_definitions_on_road_order_id"
  end

  create_table "road_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "car_type"
    t.integer "start_car"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "station_id"
    t.bigint "author_id"
    t.bigint "contract_id"
    t.string "file_path"
    t.string "positions"
    t.string "day_shifts"
    t.string "import"
    t.index ["author_id"], name: "index_road_orders_on_author_id"
    t.index ["contract_id"], name: "index_road_orders_on_contract_id"
    t.index ["station_id"], name: "index_road_orders_on_station_id"
  end

  create_table "sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "address_line_3"
    t.string "city"
    t.string "province"
    t.string "post_code"
    t.string "country"
    t.string "time_zone"
  end

  create_table "stations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "contract_id"
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_stations_on_contract_id"
  end

  create_table "uploads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "category"
    t.string "filename"
    t.string "content_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "progress"
    t.integer "total"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "site_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["site_id"], name: "index_users_on_site_id"
  end

  add_foreign_key "accesses", "contracts"
  add_foreign_key "accesses", "users"
  add_foreign_key "contracts", "sites"
  add_foreign_key "definitions", "road_orders"
  add_foreign_key "road_orders", "contracts"
  add_foreign_key "road_orders", "stations"
  add_foreign_key "road_orders", "users", column: "author_id"
  add_foreign_key "stations", "contracts"
  add_foreign_key "uploads", "users"
  add_foreign_key "users", "sites"
end
