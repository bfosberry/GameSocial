url = ENV["REDISTOGO_URL"].blank? ? "redis://127.0.0.1:6379" : ENV["REDISTOGO_URL"]
REDIS = Redis.new(:url => url)