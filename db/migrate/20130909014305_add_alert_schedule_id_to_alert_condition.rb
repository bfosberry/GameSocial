class AddAlertScheduleIdToAlertCondition < ActiveRecord::Migration
  def change
  	add_column :alert_conditions, :alert_schedule_id, :integer
  end
end
