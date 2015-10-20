class AddEventsGameSocialServerJoin < ActiveRecord::Migration
  def change
  	 create_table :events_game_social_servers do |t|
      t.integer :game_social_server_id
      t.integer :event_id
    end
  end
end
