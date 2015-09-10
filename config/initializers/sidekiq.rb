Sidekiq.configure_client do
  Sidekiq::Logging.logger.level = Logger::WARN
end

Sidekiq.configure_server do
  Sidekiq::Logging.logger.level = Logger::WARN
end
