class CreateUsersUsersJoinTable < ActiveRecord::Migration
  def change
  	create_table :friends do |t|
      t.integer :user_id
      t.integer :user_id
    end
  end
end
