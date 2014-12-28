class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.string :uid
      t.string :provider
      t.string :name
      t.string :nickname
      t.string :email
      t.string :profile_url
      t.string :image_url
      t.string :refresh_token
      t.datetime :token_expiry

      t.timestamps
    end
  end
end
