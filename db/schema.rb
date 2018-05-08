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

ActiveRecord::Schema.define(version: 2018_05_07_142056) do

  create_table "bids", force: :cascade do |t|
    t.integer "user_id"
    t.integer "lot_id"
    t.datetime "bid_creation_time", null: false
    t.float "proposed_price", null: false
    t.index ["lot_id"], name: "index_bids_on_lot_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "lots", force: :cascade do |t|
    t.integer "user_id"
    t.text "title", null: false
    t.string "image"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.float "current_price", null: false
    t.float "estimated_price", null: false
    t.datetime "lot_start_time", null: false
    t.datetime "lot_end_time", null: false
    t.index ["user_id"], name: "index_lots_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "bid_id"
    t.text "arrival_location", null: false
    t.string "arrival_type", null: false
    t.integer "status", null: false
    t.index ["bid_id"], name: "index_orders_on_bid_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "phone", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "birthdate", null: false
  end

end
