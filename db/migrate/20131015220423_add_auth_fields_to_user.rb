class AddAuthFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    add_column :users, :password_digest, :string
  end
end
