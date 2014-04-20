module Providers
  class SteamProvider
    attr_accessor :steam_id, :user
    def initialize(user)
      SteamCondenser::Community::WebApi.api_key = SECRETS['steam_api_key']
      id = SteamCondenser::Community::SteamId.community_id_to_steam_id(user.uid.to_i)
      self.steam_id = SteamCondenser::Community::SteamId.new(id)
      steam_id.fetch
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

    def current_game
      puts "Fetching game"
      puts "SECRETS"
      puts steam_id.game_name
      steam_id.game_name
    end

    def current_game_server
      steam_id.game_server_id
    end
  end
end
