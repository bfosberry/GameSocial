class AddWinnerToTournamentRound < ActiveRecord::Migration
  def change
  	add_column :tournament_rounds, :winner_id, :integer
  end
end
