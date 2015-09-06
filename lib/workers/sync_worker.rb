require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'

module Workers
  class SyncWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :sync, :retry => 2

    def perform(user_id)
      user = User.find(user_id)
      return unless user
      return if user.steam_uid.nil?
      sp = Providers::SteamProvider.new(user)
      si = Importers::SteamImporter.new(sp)
      si.import_user
      si.import_games
      if user.is_active?
        si.import_friends
      end
      user.update_attribute(:updated_at, DateTime.now)
    end
  end
end
