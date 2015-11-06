class AddUidToTournaments < ActiveRecord::Migration
  def change
  	add_column :tournaments, :uid, :string
  end
end