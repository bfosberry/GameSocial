class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.references :postable, polymorphic: true
      t.timestamps
    end
  end
end
