require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'

module Workers
  class SyncWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :sync, :retry => false

    def perform(user_id)
      user = User.find(user_id)
      sp = Providers::SteamProvider.new(user)
      si = Importers::SteamImporter.new(sp)
      si.import_user
      if user.is_active?
        si.import_games
        si.import_friends
        si.import_location
      end
    rescue SteamCondenser::Error => e
      puts "Failed to sync user"
    end
  end
end
