class AddBracketIdToTournamentRound < ActiveRecord::Migration
  def change
  	add_column :tournament_rounds, :bracket_id, :integer
  end
end
