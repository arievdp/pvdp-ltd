# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_12_051854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "animals", force: :cascade do |t|
    t.bigint "farm_id", null: false
    t.string "birth_id"
    t.integer "cow_number"
    t.datetime "birth_date"
    t.integer "bw_value"
    t.integer "bw_reliability"
    t.integer "pw_value"
    t.integer "pw_reliability"
    t.string "a2_status"
    t.string "sex"
    t.string "status"
    t.string "fate"
    t.string "expected_calving_date"
    t.string "calving_date"
    t.string "calf_birth_id"
    t.string "calf_birth_date"
    t.string "calf_sex"
    t.string "calf_fate"
    t.string "dam_birth_id"
    t.integer "dam_cow_number"
    t.string "sire_birth_id"
    t.string "sire_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["farm_id"], name: "index_animals_on_farm_id"
  end

  create_table "employments", force: :cascade do |t|
    t.bigint "farm_id", null: false
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["farm_id"], name: "index_employments_on_farm_id"
    t.index ["user_id"], name: "index_employments_on_user_id"
  end

  create_table "farms", force: :cascade do |t|
    t.string "code"
    t.string "nickname"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "animals", "farms"
  add_foreign_key "employments", "farms"
  add_foreign_key "employments", "users"
end
