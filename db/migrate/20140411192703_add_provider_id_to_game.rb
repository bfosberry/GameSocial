class AddProviderIdToGame < ActiveRecord::Migration
  def change
  	add_column :games, :provider_id, :integer
  end
end
