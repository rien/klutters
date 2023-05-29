# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_06_182610) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "uid"
    t.string "full_name", null: false
    t.string "short_name", null: false
    t.string "color", null: false
    t.boolean "verified", default: false, null: false
    t.integer "balance_cents", default: 0, null: false
    t.string "balance_currency", default: "EUR", null: false
    t.bigint "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_accounts_on_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "uid"
    t.string "link_state_token"
    t.datetime "valid_until", precision: nil
    t.string "bank", null: false
    t.string "country", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.string "other"
    t.string "raw_data", null: false
    t.string "transaction_type", null: false
    t.string "description", null: false
    t.string "status", null: false
    t.date "effective_at", null: false
    t.datetime "initiated_at"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

end
