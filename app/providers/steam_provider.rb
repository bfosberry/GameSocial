module Providers
  class SteamProvider
    attr_accessor :steam_id, :user
    def initialize(user)
      SteamCondenser::Community::WebApi.api_key = ENV['STEAM_API_KEY']
      id = SteamCondenser::Community::SteamId.community_id_to_steam_id(user.uid.to_i)
      self.steam_id = SteamCondenser::Community::SteamId.new(id)
      self.user = user
      self.steam_id ? self : nil
#    rescue SteamCondenserError
#
#      nil
    end

    def games
      steam_id.games
    end

    def friends
      steam_id.friends
    end

    def name
      steam_id.nickname
    end
  end
end
