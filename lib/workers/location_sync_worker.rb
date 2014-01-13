require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'

module Workers
  class LocationSyncWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :sync, :retry => 2

    def perform(user_id)
      user = User.find(user_id)
      puts "Syncing location for #{user.name}"
      sp = Providers::SteamProvider.new(user)
      si = Importers::SteamImporter.new(sp)
      si.import_location
      puts "Completed sync location for #{user.name}"
    rescue SteamCondenser::Error => e
      puts "Failed to sync users location"
      puts e
    end
  end
end
