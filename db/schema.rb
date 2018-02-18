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

ActiveRecord::Schema.define(version: 20180216212437) do

  create_table "accesses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_accesses_on_contract_id"
    t.index ["user_id"], name: "index_accesses_on_user_id"
  end

  create_table "back_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "bom_exp_no"
    t.bigint "station_id"
    t.bigint "contract_id"
    t.string "mrp_cont"
    t.string "component"
    t.string "material_description"
    t.string "sort_string"
    t.string "assembly"
    t.string "order"
    t.string "item_text_line_1"
    t.integer "qty"
    t.string "vendor_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cri", default: false
    t.boolean "focused_part_flag", default: false
    t.index ["contract_id"], name: "index_back_orders_on_contract_id"
    t.index ["station_id"], name: "index_back_orders_on_station_id"
  end

  create_table "car_road_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "car_id"
    t.bigint "road_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id", "road_order_id"], name: "index_car_road_orders_on_car_id_and_road_order_id", unique: true
    t.index ["car_id"], name: "index_car_road_orders_on_car_id"
    t.index ["road_order_id"], name: "index_car_road_orders_on_road_order_id"
  end

  create_table "cars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "car_type"
    t.integer "number"
    t.bigint "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_cars_on_contract_id"
    t.index ["number", "car_type", "contract_id"], name: "index_cars_on_number_and_car_type_and_contract_id", unique: true
  end

  create_table "contracts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "site_id"
    t.string "status", default: "draft", null: false
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "minimum_offset"
    t.datetime "planned_start"
    t.datetime "planned_end"
    t.datetime "actual_start"
    t.datetime "actual_end"
    t.index ["site_id"], name: "index_contracts_on_site_id"
  end

  create_table "definitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "road_order_id"
    t.string "work_location", null: false
    t.string "day", null: false
    t.string "shift", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.integer "expected_duration", null: false
    t.integer "breaks", null: false
    t.time "expected_start", null: false
    t.time "expected_end", null: false
    t.boolean "serialized", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "positions", null: false
    t.index ["road_order_id"], name: "index_definitions_on_road_order_id"
  end

  create_table "movements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "definition_id"
    t.integer "actual_duration"
    t.integer "percent_complete"
    t.bigint "car_road_order_id"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "production_critical"
    t.boolean "quality_critical"
    t.index ["car_road_order_id"], name: "index_movements_on_car_road_order_id"
    t.index ["definition_id", "car_road_order_id"], name: "index_movements_on_definition_id_and_car_road_order_id", unique: true
    t.index ["definition_id"], name: "index_movements_on_definition_id"
  end

  create_table "operators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "employee_number"
    t.string "badge"
    t.boolean "suspended", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "site_id"
    t.index ["badge"], name: "index_operators_on_badge", unique: true
    t.index ["employee_number"], name: "index_operators_on_employee_number", unique: true
    t.index ["site_id"], name: "index_operators_on_site_id"
  end

  create_table "positions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.bigint "car_road_order_id"
    t.boolean "allows_multiple"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_road_order_id"], name: "index_positions_on_car_road_order_id"
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
    t.text "day_shifts"
    t.string "import"
    t.string "work_centre"
    t.string "module"
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
    t.index ["code", "contract_id"], name: "index_stations_on_code_and_contract_id", unique: true
    t.index ["contract_id"], name: "index_stations_on_contract_id"
    t.index ["name", "contract_id"], name: "index_stations_on_name_and_contract_id", unique: true
  end

  create_table "transfer_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order", null: false
    t.string "delivery_device"
    t.string "priority", null: false
    t.string "reason_code", null: false
    t.string "name"
    t.string "code"
    t.string "installation"
    t.string "to_number", null: false
    t.string "car", null: false
    t.string "sort_string", null: false
    t.datetime "date_entered"
    t.datetime "date_received_3pl"
    t.datetime "date_staging"
    t.datetime "date_shipped_bt"
    t.datetime "date_received_bt"
    t.datetime "date_production"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "station_id"
    t.bigint "contract_id"
    t.index ["contract_id"], name: "index_transfer_orders_on_contract_id"
    t.index ["station_id"], name: "index_transfer_orders_on_station_id"
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
    t.string "first_name"
    t.string "last_name"
    t.string "employee_id"
    t.string "phone"
    t.boolean "suspended", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["site_id"], name: "index_users_on_site_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "accesses", "contracts"
  add_foreign_key "accesses", "users"
  add_foreign_key "back_orders", "contracts"
  add_foreign_key "back_orders", "stations"
  add_foreign_key "car_road_orders", "cars"
  add_foreign_key "car_road_orders", "road_orders"
  add_foreign_key "cars", "contracts"
  add_foreign_key "contracts", "sites"
  add_foreign_key "definitions", "road_orders"
  add_foreign_key "movements", "car_road_orders"
  add_foreign_key "movements", "definitions"
  add_foreign_key "operators", "sites"
  add_foreign_key "positions", "car_road_orders"
  add_foreign_key "road_orders", "contracts"
  add_foreign_key "road_orders", "stations"
  add_foreign_key "road_orders", "users", column: "author_id"
  add_foreign_key "stations", "contracts"
  add_foreign_key "transfer_orders", "contracts"
  add_foreign_key "transfer_orders", "stations"
  add_foreign_key "uploads", "users"
  add_foreign_key "users", "sites"
end
