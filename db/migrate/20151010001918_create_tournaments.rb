class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.text :description
      t.integer :num_teams
      t.integer :team_max_size
      t.integer :team_min_size
      t.integer :games_per_round
      t.integer :teams_per_round
      t.integer :brackets
      t.boolean :public_teams
      t.integer :lead_time
      t.integer :num_parallel_events
      t.integer :time_between_rounds
      t.string :time_rounding
      t.string :event_earliest_time
      t.string :event_latest_time
      t.integer :user_id
      t.integer :event_id

      t.timestamps
    end

    add_index :tournaments, :user_id
    add_index :tournaments, :event_id
  end
end
