class AddLocationToGameEvent < ActiveRecord::Migration
  def change
  	add_column :game_events, :location, :string
  end
end
