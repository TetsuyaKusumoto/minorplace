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

ActiveRecord::Schema.define(version: 20151108080611) do

  create_table "ownerships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.string   "type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "comment"
  end

  add_index "ownerships", ["place_id"], name: "index_ownerships_on_place_id"
  add_index "ownerships", ["user_id", "place_id", "type"], name: "index_ownerships_on_user_id_and_place_id_and_type", unique: true
  add_index "ownerships", ["user_id"], name: "index_ownerships_on_user_id"

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "area"
    t.string   "prefecture"
    t.string   "address"
    t.float    "longitude"
    t.string   "create_user_name"
    t.string   "category"
    t.string   "comment"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.float    "latitude"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "area"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "email"
    t.string   "description"
    t.string   "password_digest"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "prefecture"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
