class AddLockedToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :locked, :bool
  end
end
