json.array!(@alerts) do |alert|
  json.extract! alert, :alert_schedule_id, :payload, :title, :description
  json.url alert_url(alert, format: :json)
end
