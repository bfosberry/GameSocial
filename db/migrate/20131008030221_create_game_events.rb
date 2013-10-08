class CreateGameEvents < ActiveRecord::Migration
  def change
    create_table :game_events do |t|
      t.integer :event_id
      t.string :title
      t.text :description
      t.integer :game_id
      t.integer :game_social_server_id
      t.integer :chat_server_id
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
