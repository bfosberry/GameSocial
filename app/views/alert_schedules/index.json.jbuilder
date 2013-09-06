json.array!(@alert_schedules) do |alert_schedule|
  json.extract! alert_schedule, :user_id, :name
  json.url alert_schedule_url(alert_schedule, format: :json)
end
