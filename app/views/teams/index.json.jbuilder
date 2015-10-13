json.array!(@teams) do |team|
  json.extract! team, :id, :tournament_id, :user_id, :name
  json.url team_url(team, format: :json)
end
