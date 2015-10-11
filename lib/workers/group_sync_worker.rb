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
     
      si.import_group(group_steam_id, clear_cache)
      
      user.update_attribute(:updated_at, DateTime.now)
    end

    sidekiq_retry_in do |count|
      5 * 60
    end
  end
end
