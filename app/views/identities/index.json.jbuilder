json.array!(@games) do |game|
  json.extract! game, :name, :store_url, :description, :logo_url
  json.url game_url(game, format: :json)
end
