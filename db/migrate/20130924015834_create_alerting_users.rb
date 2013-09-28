class CreateAlertingUsers < ActiveRecord::Migration
  def change
    create_table :alerting_users do |t|
      t.integer :user_id
      t.integer :alert_schedule_id

      t.timestamps
    end
  end
end
