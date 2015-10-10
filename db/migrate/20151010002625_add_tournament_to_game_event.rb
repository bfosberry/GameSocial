class AddTournamentToGameEvent < ActiveRecord::Migration
  def change
    add_column :game_events, :tournament_id, :integer
    add_index :game_events, :tournament_id
  end
end
