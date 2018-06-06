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

ActiveRecord::Schema.define(version: 2018_06_06_104928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bids", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "lot_id"
    t.datetime "created_at", null: false
    t.float "proposed_price", null: false
    t.index ["lot_id"], name: "index_bids_on_lot_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "lots", force: :cascade do |t|
    t.bigint "user_id"
    t.text "title", null: false
    t.string "image"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.float "current_price", null: false
    t.float "estimated_price", null: false
    t.datetime "lot_start_time", null: false
    t.datetime "lot_end_time", null: false
    t.string "lot_jid_in_process"
    t.string "lot_jid_closed"
    t.integer "winning_bid"
    t.index ["user_id"], name: "index_lots_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "bid_id"
    t.text "arrival_location", null: false
    t.integer "arrival_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.index ["bid_id"], name: "index_orders_on_bid_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "phone", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "birthday", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.json "tokens"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

end
