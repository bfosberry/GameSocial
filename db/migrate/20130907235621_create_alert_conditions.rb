class CreateAlertConditions < ActiveRecord::Migration
  def change
    create_table :alert_conditions do |t|
      t.string :condition_type
      t.text :value

      t.timestamps
    end
  end
end
