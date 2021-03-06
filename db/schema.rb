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

ActiveRecord::Schema.define(version: 20151106172619) do

  create_table "alert_conditions", force: :cascade do |t|
    t.string   "condition_type"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alert_schedule_id"
  end

  add_index "alert_conditions", ["alert_schedule_id"], name: "index_alert_conditions_on_alert_schedule_id"

  create_table "alert_schedules", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alert_schedules", ["user_id"], name: "index_alert_schedules_on_user_id"

  create_table "alerting_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "alert_schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerts", force: :cascade do |t|
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

  add_index "alerts", ["alert_schedule_id"], name: "index_alerts_on_alert_schedule_id"

  create_table "chat_servers", force: :cascade do |t|
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
    t.string   "url"
  end

  add_index "chat_servers", ["user_id"], name: "index_chat_servers_on_user_id"

  create_table "credentials", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "profile_url"
    t.string   "image_url"
    t.string   "refresh_token"
    t.datetime "token_expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "credentials", ["user_id"], name: "index_credentials_on_user_id"

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "start_time",  null: false
    t.datetime "end_time",    null: false
    t.integer  "user_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "image_url"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "events_game_social_servers", force: :cascade do |t|
    t.integer "game_social_server_id"
    t.integer "event_id"
  end

  create_table "events_users", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "user_id",  null: false
  end

  create_table "friends", force: :cascade do |t|
    t.integer "user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_events", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "title"
    t.text     "description"
    t.integer  "game_id"
    t.integer  "game_social_server_id"
    t.integer  "chat_server_id"
    t.integer  "user_id"
    t.datetime "game_start_time",       null: false
    t.datetime "game_end_time",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.integer  "tournament_id"
    t.string   "location"
  end

  add_index "game_events", ["chat_server_id"], name: "index_game_events_on_chat_server_id"
  add_index "game_events", ["event_id"], name: "index_game_events_on_event_id"
  add_index "game_events", ["game_id"], name: "index_game_events_on_game_id"
  add_index "game_events", ["game_social_server_id"], name: "index_game_events_on_game_social_server_id"
  add_index "game_events", ["tournament_id"], name: "index_game_events_on_tournament_id"
  add_index "game_events", ["user_id"], name: "index_game_events_on_user_id"

  create_table "game_events_users", id: false, force: :cascade do |t|
    t.integer "game_event_id", null: false
    t.integer "user_id",       null: false
  end

  create_table "game_locations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "game_social_server_id"
    t.integer  "chat_server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_locations", ["user_id"], name: "index_game_locations_on_user_id"

  create_table "game_social_servers", force: :cascade do |t|
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

  add_index "game_social_servers", ["game_id"], name: "index_game_social_servers_on_game_id"
  add_index "game_social_servers", ["user_id"], name: "index_game_social_servers_on_user_id"

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.text     "store_url"
    t.text     "description"
    t.text     "logo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "provider_id"
    t.string   "provider"
  end

  add_index "games", ["name"], name: "index_games_on_name"
  add_index "games", ["provider_id", "provider"], name: "index_games_on_provider_id_and_provider"
  add_index "games", ["provider_id"], name: "index_games_on_provider_id"

  create_table "games_playlists", force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "game_id"
  end

  create_table "games_users", force: :cascade do |t|
    t.integer "game_id"
    t.integer "user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "provider_id"
    t.string   "avatar_url"
    t.string   "url"
  end

  add_index "groups", ["name"], name: "index_groups_on_name"
  add_index "groups", ["user_id"], name: "index_groups_on_user_id"

  create_table "groups_users", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "object_permissions", force: :cascade do |t|
    t.string   "permission_type"
    t.integer  "permissible_object_id"
    t.string   "permissible_object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "object_permissions_users", id: false, force: :cascade do |t|
    t.integer "object_permission_id"
    t.integer "user_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "postable_id"
    t.string   "postable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["postable_id", "postable_type"], name: "index_posts_on_postable_id_and_postable_type"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "team_members", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["tournament_id"], name: "index_teams_on_tournament_id"

  create_table "teams_tournament_rounds", force: :cascade do |t|
    t.integer "tournament_round_id"
    t.integer "team_id"
  end

  create_table "tournament_rounds", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "game_event_id"
    t.string   "score"
    t.string   "round_type"
    t.integer  "round_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
    t.integer  "bracket_id"
    t.string   "conceded"
    t.integer  "num_teams"
  end

  add_index "tournament_rounds", ["tournament_id"], name: "index_tournament_rounds_on_tournament_id"

# Could not dump table "tournaments" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "remember_token"
    t.string   "password_digest"
    t.string   "status",          default: "Inactive"
    t.string   "name"
    t.string   "email"
    t.string   "avatar_url"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
