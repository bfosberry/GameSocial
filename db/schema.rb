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

ActiveRecord::Schema.define(version: 20140411192703) do

  create_table "alert_conditions", force: true do |t|
    t.string   "condition_type"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alert_schedule_id"
  end

  create_table "alert_schedules", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerting_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "alert_schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerts", force: true do |t|
    t.integer  "alert_schedule_id"
    t.text     "payload"
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.datetime "delivered_at"
    t.boolean  "active"
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

  create_table "events", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_time",  default: '2014-03-24 13:06:55'
    t.datetime "end_time",    default: '2014-03-24 19:06:55'
    t.integer  "user_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_users", id: false, force: true do |t|
    t.integer "event_id", null: false
    t.integer "user_id",  null: false
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

  create_table "game_events", force: true do |t|
    t.integer  "event_id"
    t.string   "title"
    t.text     "description"
    t.integer  "game_id"
    t.integer  "game_social_server_id"
    t.integer  "chat_server_id"
    t.integer  "user_id"
    t.datetime "start_time",            default: '2014-03-24 13:06:55'
    t.datetime "end_time",              default: '2014-03-24 14:06:55'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_events_users", id: false, force: true do |t|
    t.integer "game_event_id", null: false
    t.integer "user_id",       null: false
  end

  create_table "game_locations", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "game_social_server_id"
    t.integer  "chat_server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_social_servers", force: true do |t|
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
    t.integer  "provider_id"
  end

  create_table "games_users", force: true do |t|
    t.integer "game_id"
    t.integer "user_id"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "postable_id"
    t.string   "postable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.boolean  "admin"
    t.string   "remember_token"
    t.string   "password_digest"
    t.string   "status",          default: "Inactive"
  end

end
