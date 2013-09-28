class RenameGameServerToGameSocialServerForGameLocation < ActiveRecord::Migration
  def change
  	rename_column :game_locations, :game_server_id, :game_social_server_id
  end
end
