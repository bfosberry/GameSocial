class ConvertTypeToServerType < ActiveRecord::Migration
  def change
  	rename_column :chat_servers, :type, :server_type
  end
end
