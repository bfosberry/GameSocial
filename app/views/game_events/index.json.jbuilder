json.array!(@game_events) do |game_event|
  json.extract! game_event, :event_id, :title, :description, :game_id, :game_social_server_id, :chat_server_id, :user_id, :start_time, :end_time
  json.url game_event_url(game_event, format: :json)
end
