class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end
 
    create_table :games_playlists do |t|
      t.integer :playlist_id
      t.integer :game_id
    end
  end
end
