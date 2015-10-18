class AddConcedingToTournamentRound < ActiveRecord::Migration
  def change
  	add_column :tournament_rounds, :conceded, :string
  end
end
