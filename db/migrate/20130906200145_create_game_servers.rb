class CreateGameServers < ActiveRecord::Migration
  def change
    create_table :game_servers do |t|
      t.string :name
      t.string :ip
      t.integer :port
      t.integer :game_id
      t.integer :max_players
      t.integer :current_players
      t.integer :latency
      t.string :current_map
      t.string :match_type
      t.string :region

      t.timestamps
    end
  end
end
