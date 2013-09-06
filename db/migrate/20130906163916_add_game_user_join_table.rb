class AddGameUserJoinTable < ActiveRecord::Migration
  def change
  	create_table :games_users do |t|
      t.integer :game_id
      t.integer :user_id
    end
  end
end
