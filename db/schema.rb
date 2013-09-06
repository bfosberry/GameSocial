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

ActiveRecord::Schema.define(version: 20130906212613) do

  create_table "alert_schedules", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_servers", force: true do |t|
    t.string   "server_type"
    t.integer  "user_id"
    t.string   "ip"
    t.integer  "port"
    t.boolean  "public"
    t.string   "name"
    t.string   "password"
    t.string   "room"
    t.string   "room_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", force: true do |t|
    t.integer "user_id"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_locations", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "game_server_id"
    t.integer  "chat_server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_servers", force: true do |t|
    t.string   "name"
    t.string   "ip"
    t.integer  "port"
    t.integer  "game_id"
    t.integer  "max_players"
    t.integer  "current_players"
    t.integer  "latency"
    t.string   "current_map"
    t.string   "match_type"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.text     "store_url"
    t.text     "description"
    t.text     "logo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_users", force: true do |t|
    t.integer "game_id"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
