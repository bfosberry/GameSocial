class AddStartTimeToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :tournament_start_time, :datetime, :null=>false, :default=>'now()'
  end
end
