json.array!(@game_locations) do |game_location|
  json.extract! game_location, :user_id, :game_id, :game_server_id, :chat_server_id
  json.url game_location_url(game_location, format: :json)
end
