json.array!(@events) do |event|
  json.extract! event, :name, :description, :start_time, :end_time, :user_id, :location
  json.url event_url(event, format: :json)
end
