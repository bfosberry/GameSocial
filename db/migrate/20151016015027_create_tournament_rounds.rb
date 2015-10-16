class CreateTournamentRounds < ActiveRecord::Migration
  def change
    create_table :tournament_rounds do |t|
      t.integer :tournament_id
      t.integer :game_event_id
      t.string :score
      t.string :round_type
      t.integer :round_index

      t.timestamps
    end

    add_index :tournament_rounds, :tournament_id
  end
end
