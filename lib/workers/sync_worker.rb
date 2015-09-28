require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'

module Workers
  class SyncWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :sync, :retry => 10

    def perform(user_id, clear_cache=false)
      user = User.find(user_id)
      return unless user
      return if user.steam_uid.blank?
      sp = Providers::SteamProvider.new(user)
      sp.clear_cache if clear_cache
      si = Importers::SteamImporter.new(sp)
      si.import_user
      si.import_games
      si.import_groups
      if user.is_active?
        si.import_friends
      end
      user.update_attribute(:updated_at, DateTime.now)
    end
  end
end
