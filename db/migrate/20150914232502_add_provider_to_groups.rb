class AddProviderToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :provider, :string
    add_column :groups, :provider_id, :string
    add_column :groups, :avatar_url, :string
    add_column :groups, :url, :string
  end
end
