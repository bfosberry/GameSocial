json.array!(@tournaments) do |tournament|
  json.extract! tournament, :id, :name, :description, :num_teams, :team_max_size, :team_min_size, :games_per_round, :teams_per_round, :brackets, :public_teams, :lead_time, :num_parallel_events, :time_between_rounds, :time_rounding, :event_earliest_time, :event_latest_time
  json.url tournament_url(tournament, format: :json)
end
