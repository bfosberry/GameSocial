json.array!(@game_servers) do |game_server|
  json.extract! game_server, :name, :ip, :port, :game_id, :max_players, :current_players, :latency, :current_map, :match_type, :region
  json.url game_server_url(game_server, format: :json)
end
