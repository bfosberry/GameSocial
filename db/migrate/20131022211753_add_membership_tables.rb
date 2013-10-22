class AddMembershipTables < ActiveRecord::Migration
  def change
    create_table :events_users, :id => false do |t|
      t.references :event, :null => false
      t.references :user, :null => false
    end
    create_table :game_events_users, :id => false do |t|
      t.references :game_event, :null => false
      t.references :user, :null => false
    end
  end
end
