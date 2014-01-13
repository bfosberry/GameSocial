require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'

module Workers
  class ImportWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :sync, :retry => 2

    def perform(user_id)
      user = User.find(user_id)
      sp = Providers::SteamProvider.new(user)
      si = Importers::SteamImporter.new(sp)
      si.import_user
      si.import_games
      si.import_location
      si.import_friends
      for f in user.friends
        f.refresh_data
      end
    rescue SteamCondenser::Error => e
      puts "Failed to import user"
      puts e
    end
  end
end
