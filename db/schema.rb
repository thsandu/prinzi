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

ActiveRecord::Schema.define(version: 2018_09_27_091212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buchungs", force: :cascade do |t|
    t.string "status", null: false
    t.datetime "start", null: false
    t.datetime "ende", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "typ", default: "standard", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "typ"
    t.string "name"
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "verfugbarkeits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "verfügbar", null: false
    t.datetime "start", null: false
    t.datetime "ende", null: false
    t.bigint "user_id"
    t.string "gcal_id"
    t.index ["user_id"], name: "index_verfugbarkeits_on_user_id"
  end

  add_foreign_key "verfugbarkeits", "users"
end
