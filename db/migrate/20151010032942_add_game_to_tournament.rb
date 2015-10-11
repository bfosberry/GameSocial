class AddGameToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :game_id, :integer
  end
end
