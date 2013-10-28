class AddStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, :default => "Inactive"
    User.all.each {|u| u.update_attribute(:status, "Active") }
  end
end
