json.array!(@playlists) do |playlist|
  json.extract! playlist, :id
  json.url playlist_url(playlist, format: :json)
end
