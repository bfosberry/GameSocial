class AddDelieveryToAlert < ActiveRecord::Migration
  def change
  	add_column :alerts, :status, :string
  	add_column :alerts, :delivered_at, :datetime
  	add_column :alerts, :active, :boolean
  end
end
