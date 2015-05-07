module Providers
  class SteamProvider
    attr_accessor :steam_id, :user
    def initialize(user)
      WebApi.api_key = ENV['STEAM_API_KEY']
      id = SteamId.community_id_to_steam_id(user.steam_uid.to_i)
      self.steam_id = SteamId.new(id)
      self.user = user
      self.steam_id ? self : nil
    end

    def games
      steam_id.games
    rescue
      {}
    end

    def friends
      steam_id.friends
    rescue 
      {}
    end

    def name
      steam_id.nickname
    end

    def avatar_url
      steam_id.full_avatar_url
    end

    def current_game
      steam_id.game_name
    end

    def current_game_server
      steam_id.game_server_id
    end
  end
end
