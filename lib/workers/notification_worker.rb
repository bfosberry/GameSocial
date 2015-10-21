require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'

module Workers
  class NotificationWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :alert, :retry => 5

    def perform(user_id, title)
      user = User.find(user_id)
      notification = Notification.new(title)
      user.notify_websocket(notification)
    end
  end
end
