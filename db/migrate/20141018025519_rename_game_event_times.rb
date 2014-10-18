class RenameGameEventTimes < ActiveRecord::Migration
  def change
  	rename_column :game_events, :start_time, :game_start_time
  	rename_column :game_events, :end_time, :game_end_time
  end
end
