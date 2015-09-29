require './app/providers/steam_provider.rb'
require './app/importers/steam_importer.rb'
require 'steam-condenser'

module Workers
  class GroupSyncWorker
    include Sidekiq::Worker
    sidekiq_options :queue => :group_sync

    def perform(user_id, group_steam_id, clear_cache=false)
      user = User.find(user_id)
      return unless user
      return if user.steam_uid.blank?
      sp = Providers::SteamProvider.new(user)
      si = Importers::SteamImporter.new(sp)
     
      #group_throttle = Sidekiq::Limiter.window("steam-groups", 15, :minute, wait_timeout: 60)
      #group_throttle.within_limit do
        si.import_group(group_steam_id, clear_cache)
      #end

      user.update_attribute(:updated_at, DateTime.now)
    end
  end
end
