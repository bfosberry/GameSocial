json.array!(@chat_servers) do |chat_server|
  json.extract! chat_server, :type, :user_id, :ip, :port, :public, :name, :password, :room, :room_password
  json.url chat_server_url(chat_server, format: :json)
end
