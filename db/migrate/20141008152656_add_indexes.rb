class AddIndexes < ActiveRecord::Migration
  def change
  	#standard join indexes
  	add_index :alert_conditions, :alert_schedule_id
  	add_index :alert_schedules, :user_id
  	add_index :alerts, :alert_schedule_id
  	add_index :chat_servers, :user_id
  	add_index :events, :user_id
  	add_index :game_events, :event_id
  	add_index :game_events, :user_id
  	add_index :game_events, :game_social_server_id
  	add_index :game_events, :game_id
  	add_index :game_events, :chat_server_id
  	add_index :game_social_servers, :game_id
  	add_index :game_social_servers, :user_id
  	add_index :posts, :user_id
  	add_index :posts, [:postable_id, :postable_type]

    #usage based indexes
    add_index :games, :provider_id
    add_index :games, :name
    add_index :users, [:uid, :provider]
    add_index :users, :remember_token
    add_index :users, :name
  end
end
