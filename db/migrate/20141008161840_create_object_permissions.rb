class CreateObjectPermissions < ActiveRecord::Migration
  def change
    create_table :object_permissions do |t|
      t.string :permission_type
      t.references :permissible_object, polymorphic: true
      t.timestamps
    end

    create_table :object_permissions_users, id: false do |t|
      t.belongs_to :object_permission
      t.belongs_to :user
    end
  end
end
