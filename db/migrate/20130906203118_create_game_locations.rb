class CreateGameLocations < ActiveRecord::Migration
  def change
    create_table :game_locations do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :game_server_id
      t.integer :chat_server_id

      t.timestamps
    end
  end
end
