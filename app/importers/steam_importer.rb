require './app/providers/steam_provider.rb'

module Importers
  class SteamImporter
    attr_accessor :steam_provider
    def initialize(steam_provider)
      self.steam_provider = steam_provider
    end

    def import_games
      user = steam_provider.user
      keys = steam_provider.games.keys
      if keys
        keys.each do |k|
          game = Game.find_by_provider_id(k)
          unless game
            g = steam_provider.games[k]
            game = Game.create({
              :provider_id => k,
              :provider => "steam",
              :name => g.name,
              :store_url => g.store_url,
              :logo_url => g.logo_url,
              :description => g.name
             })
          end
          user.games << game unless user.games.include?(game)
        end  
      end
      user.save
    end

    def import_friends
      steam_provider.friends.each do |f|
        u = create_user_from_friend(f)
        if u
          user = steam_provider.user
          u.friends << user unless u.friends.include? user
          user.friends << u unless user.friends.include? u
        end
      end
    end

    def create_user_from_friend(f)
      f.fetch
      if f.steam_id64.to_i > 0
        c = Credential.where({ :uid => f.steam_id64.to_s, :provider => "steam" }).first_or_create
        c.update_attributes({
            nickname: f.nickname,
            image_url: f.full_avatar_url,
            name: f.real_name,
            profile_url: f.base_url
        })
        u = c.user
        unless u
          u = User.new
        end
        u.update_attributes({ :name => f.nickname,
                              :avatar_url => f.full_avatar_url })
        u.save
        u.credentials << c
        return u
      end
    rescue SteamCondenser::Error; end

    def import_user
      steam_provider.user.update_attributes({ :name => steam_provider.name,
                                              :avatar_url => steam_provider.avatar_url })
    end

    def import_location
      game_name = steam_provider.current_game
      game_server_ip = steam_provider.current_game_server
      steam_provider.user.set_game(game_name, game_server_ip)
    end
  end
end
