class AddTournamentRoundTeam < ActiveRecord::Migration
  def change
  	create_table :tournament_rounds_teams do |t|
      t.integer :tournament_round_id
      t.integer :team_id
    end
  end
end
