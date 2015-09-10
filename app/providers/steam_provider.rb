module Providers
  class SteamProvider
    attr_accessor :steam_id, :user
    GAMES_EXPIRY=12.hours
    FRIENDS_EXPIRY=12.hours
    NAME_EXPIRY=12.hours
    AVATAR_URL_EXPIRY=12.hours
    SUMMARY_EXPIRY=1.minutes
    def initialize(user)
      self.user = user
      SteamCondenser::Community::WebApi.api_key = ENV['STEAM_API_KEY']
      self.steam_id = SteamCondenser::Community::SteamId.new(user.steam_uid.to_i)
      self.steam_id ? self : nil
    end

    def games
      Rails.cache.fetch(game_cache_key, :expires_in => GAMES_EXPIRY) do
        steam_id.games
      end
    rescue
      {}
    end

    def friends
      Rails.cache.fetch(friends_cache_key, :expires_in => FRIENDS_EXPIRY) do
        steam_id.friends
      end
    rescue 
      {}
    end

    def name
      Rails.cache.fetch(name_cache_key, :expires_in => NAME_EXPIRY) do
        steam_id.nickname
      end
    end

    def avatar_url
      Rails.cache.fetch(avatar_url_cache_key, :expires_in => AVATAR_URL_EXPIRY) do
        steam_id.full_avatar_url
      end
    end

    def current_game
      summary[:game_name] if summary
    end

    def current_game_server
      summary[:game_server_ip] if summary
    end

    def summary
      Rails.cache.fetch(summary_cache_key, :expires_in => SUMMARY_EXPIRY) do
        steam_id.summary
      end
    end

    def games_cache_key
      "steam_#{user.id}_#{user.steam_uid}_games"
    end

    def friends_cache_key
      "steam_#{user.id}_#{user.steam_uid}_friends"
    end

    def name_cache_key
      "steam_#{user.id}_#{user.steam_uid}_name"
    end

    def avatar_url_cache_key
      "steam_#{user.id}_#{user.steam_uid}_avatar_url"
    end

    def summary_cache_key
      "steam_#{user.id}_#{user.steam_uid}_summary"
    end
  end
end
