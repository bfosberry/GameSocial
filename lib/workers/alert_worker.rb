require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'

module Workers
  class AlertWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :alert, :retry => false

    def perform(alert_id)
      alert = Alert.find(alert_id)
      unless alert.delivered?
      	alert.update_attributes({:status => "Sending"})
        AlertMailer.alert_email(alert).deliver

      	alert.update_attributes({:status => "Delivered", :delivered_at => DateTime.now})
      end
    end
  end
end
