class AddProviderToGame < ActiveRecord::Migration
  def change
  	add_column :games, :provider, :string
  	Game.where("provider is NULL").each do |g|
      g.provider = "steam"
      g.save
  	end
  end
end
