json.array!(@users) do |user|
  json.extract! user, :provider, :uid, :name
  json.url user_url(user, format: :json)
end
