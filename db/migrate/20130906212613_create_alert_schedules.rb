class CreateAlertSchedules < ActiveRecord::Migration
  def change
    create_table :alert_schedules do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
