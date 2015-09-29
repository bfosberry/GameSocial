  module Providers
  class SteamProvider
    attr_accessor :steam_id, :user
    GAMES_EXPIRY=12.hours
    FRIENDS_EXPIRY=12.hours
    GROUP_EXPIRY=12.hours
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
      Rails.cache.fetch(games_cache_key, :expires_in => GAMES_EXPIRY) do
        steam_id.games
      end
    end

    def friends
      Rails.cache.fetch(friends_cache_key, :expires_in => FRIENDS_EXPIRY) do
        steam_id.friends
      end
    end

    def groups
      steam_id.groups
    end

    def group(group_id, clear_cache=false)
      Rails.cache.delete(group_cache_key(group_id)) if clear_cache
      Rails.cache.fetch(group_cache_key(group_id), :expires_in => GROUP_EXPIRY) do
        group = SteamCondenser::Community::SteamGroup.new(group_id.to_i, false)
        group.fetch unless group.name
        group_to_dict(group)
      end
    end

    def group_to_dict(group)
      {
        :id  => group.group_id64,
        :name => group.name,
        :avatar_full_url => group.avatar_full_url,
        :avatar_icon_url => group.avatar_icon_url,
        :avatar_medium_url => group.avatar_medium_url,
        :headline => group.headline,
        :summary => group.summary
      }
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

    def group_cache_key(id)
      "steam_group_#{id}"
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

    def clear_cache
      Rails.cache.delete(games_cache_key)
      Rails.cache.delete(friends_cache_key)
      Rails.cache.delete(name_cache_key)
      Rails.cache.delete(avatar_url_cache_key)
      Rails.cache.delete(summary_cache_key)
    end
  end
end
