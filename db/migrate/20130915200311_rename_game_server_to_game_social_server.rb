class RenameGameServerToGameSocialServer < ActiveRecord::Migration
  def self.up
    rename_table :game_servers, :game_social_servers
  end 
  def self.down
    rename_table :game_social_servers, :game_servers
  end
end
