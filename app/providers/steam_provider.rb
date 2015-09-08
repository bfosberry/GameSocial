module Providers
  class SteamProvider
    attr_accessor :steam_id, :user
    def initialize(user)
      self.user = user
      SteamCondenser::Community::WebApi.api_key = ENV['STEAM_API_KEY']
      self.steam_id = SteamCondenser::Community::SteamId.new(user.steam_uid.to_i)
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
      steam_id.summary[:game_name] if steam_id.summary
    end

    def current_game_server
      steam_id.summary[:game_server_ip] if steam_id.summary
    end
  end
end
