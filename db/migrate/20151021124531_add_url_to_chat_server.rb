class AddUrlToChatServer < ActiveRecord::Migration
  def change
  	add_column :chat_servers, :url, :string
  end
end
