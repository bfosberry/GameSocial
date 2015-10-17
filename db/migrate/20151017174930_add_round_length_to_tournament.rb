class AddRoundLengthToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :round_length, :integer
  end
end
