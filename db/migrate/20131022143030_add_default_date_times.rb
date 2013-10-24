class AddDefaultDateTimes < ActiveRecord::Migration
  def change
    change_column :events, :start_time, :datetime, :default => DateTime.now
    change_column :events, :end_time, :datetime, :default => (DateTime.now + 6.hours)
    change_column :game_events, :start_time, :datetime, :default => DateTime.now
    change_column :game_events, :end_time, :datetime, :default => (DateTime.now + 1.hours)
  end
end
