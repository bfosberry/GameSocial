class AddUserToGameServer < ActiveRecord::Migration
  def change
  	add_column :game_servers, :user_id, :integer
  end
end
