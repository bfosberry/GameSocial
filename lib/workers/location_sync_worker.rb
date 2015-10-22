require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'
require 'steam-condenser'
module Workers
  class LocationSyncWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :sync_location, :retry => 10

    def perform(user_id)
      user = User.find(user_id)
      return unless user
      return if user.steam_uid.blank?
      logger.debug "Syncing location for #{user.name}"
      sp = Providers::SteamProvider.new(user)
      si = Importers::SteamImporter.new(sp)
      si.import_location
      logger.debug "Completed sync location for #{user.name}"
    rescue SteamCondenser::Error => e
      raise Exception.new(e.message)
    end
  end
end
