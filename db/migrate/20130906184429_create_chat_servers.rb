class CreateChatServers < ActiveRecord::Migration
  def change
    create_table :chat_servers do |t|
      t.string :type
      t.integer :user_id
      t.string :ip
      t.integer :port
      t.boolean :public
      t.string :name
      t.string :password
      t.string :room
      t.string :room_password

      t.timestamps
    end
  end
end
