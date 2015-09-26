REDIS_URI = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379")
REDIS = Redis.new(:url => REDIS_URI, :namespace => "gamekick_#{Rails.env}")
