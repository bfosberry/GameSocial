class RemoveOauthFieldsFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :uid
  	remove_column :users, :name
  	remove_column :users, :email
  	remove_column :users, :provider
  	remove_column :users, :avatar_url
  end
end
