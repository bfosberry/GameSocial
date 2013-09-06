class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.text :store_url
      t.text :description
      t.text :logo_url

      t.timestamps
    end
  end
end
