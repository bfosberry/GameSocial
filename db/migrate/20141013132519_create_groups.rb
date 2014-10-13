class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end

    add_index :groups, :user_id
    add_index :groups, :name
  end
end
