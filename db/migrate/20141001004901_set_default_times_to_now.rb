class SetDefaultTimesToNow < ActiveRecord::Migration
  def change
    change_column :events, :start_time, :datetime, :null=>false, :default=>'now()'
    change_column :events, :end_time, :datetime, :null=>false, :default=>'now()'
    change_column :game_events, :end_time, :datetime, :null=>false, :default=>'now()'
    change_column :game_events, :start_time, :datetime, :null=>false, :default=>'now()'
  end
end
