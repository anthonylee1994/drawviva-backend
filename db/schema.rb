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

ActiveRecord::Schema[7.0].define(version: 2022_03_04_100913) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "draw_items", force: :cascade do |t|
    t.bigint "draw_id", null: false
    t.string "name", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["draw_id"], name: "index_draw_items_on_draw_id"
    t.index ["name"], name: "index_draw_items_on_name"
  end

  create_table "draws", force: :cascade do |t|
    t.string "name", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_draws_on_name"
  end

  create_table "push_notification_subscriptions", force: :cascade do |t|
    t.string "endpoint"
    t.string "p256dh"
    t.string "auth"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_push_notification_subscriptions_on_user_id"
  end

  create_table "user_draws", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "draw_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["draw_id"], name: "index_user_draws_on_draw_id"
    t.index ["user_id"], name: "index_user_draws_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "display_name", null: false
    t.string "photo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "draw_items", "draws"
  add_foreign_key "push_notification_subscriptions", "users"
  add_foreign_key "user_draws", "draws"
  add_foreign_key "user_draws", "users"
end
