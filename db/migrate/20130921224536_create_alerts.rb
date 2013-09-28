class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :alert_schedule_id
      t.text :payload
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
