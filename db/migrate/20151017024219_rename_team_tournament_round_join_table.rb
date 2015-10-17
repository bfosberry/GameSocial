class RenameTeamTournamentRoundJoinTable < ActiveRecord::Migration
  def change
  	rename_table :tournament_rounds_teams, :teams_tournament_rounds
  end
end
