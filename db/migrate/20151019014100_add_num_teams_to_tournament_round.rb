class AddNumTeamsToTournamentRound < ActiveRecord::Migration
  def change
  	add_column :tournament_rounds, :num_teams, :integer
  end
end
