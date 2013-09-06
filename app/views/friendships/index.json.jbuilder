json.array!(@friendships) do |friendship|
  json.extract! friendship, :user_id, :friend_id
  json.url friendship_url(friendship, format: :json)
end
