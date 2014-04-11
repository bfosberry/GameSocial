Sidekiq.configure_server do |config|
    config.redis = { url: SECRETS["redis_server"], namespace: "GameSocial_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
    config.redis = { url: SECRETS["redis_server"], namespace: "GameSocial_#{Rails.env}" }
end 
