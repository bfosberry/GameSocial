module Importers
  class SteamImporter
    attr_accessor :steam_provider
    def initialize(steam_provider)
      self.steam_provider = steam_provider
      self
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
        if f.id.to_i > 0
          c = Credential.where({ :uid => f.id.to_s, :provider => "steam" }).first
          u = c.user if c
          if u
            user = steam_provider.user
            u.friends << user unless u.friends.include? user
            user.friends << u unless user.friends.include? u
          end
        end
      end
    end

    def import_user
      steam_provider.user.update_attributes({ :name => steam_provider.name,
                                              :avatar_url => steam_provider.avatar_url })
    end

    def import_location
      game_name = steam_provider.current_game
      steam_provider.user.set_game(game_name)
    end
  end
end
