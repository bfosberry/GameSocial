require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'

module Workers
  class LocationSyncWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :sync, :retry => false

    def perform(user_id)
      user = User.find(user_id)
      sp = Providers::SteamProvider.new(user)
      si = Importers::SteamImporter.new(sp)
      si.import_location
    rescue SteamCondenser::Error => e
      puts "Failed to sync users location"
    end
  end
end
