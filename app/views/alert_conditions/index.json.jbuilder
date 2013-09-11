json.array!(@alert_conditions) do |alert_condition|
  json.extract! alert_condition, :condition_type, :value
  json.url alert_condition_url(alert_condition, format: :json)
end
