class AddUidToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :uid, :string
  	add_column :game_events, :uid, :string
  end
end
