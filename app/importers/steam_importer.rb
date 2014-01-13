module Importers
  class SteamImporter
    attr_accessor :steam_provider
    def initialize(steam_provider)
      self.steam_provider = steam_provider
      self
    end

    def import_games
      user = steam_provider.user
      steam_provider.games.keys.each do |k|
        g = steam_provider.games[k]
        game = Game.find_or_create_by({
          :name => g.name,
          :store_url => g.store_url,
          :logo_url => g.logo_url,
          :description => g.name
        })
        user.games << game unless user.games.include?(game)
      end
      user.save
    end

    def import_friends
      steam_provider.friends.each do |f|
        if f.id.to_i > 0
          u = User.find_or_create_by({ :uid => f.id.to_s, :provider => "steam" })
          user = steam_provider.user
          u.friends << user unless u.friends.include? user
          user.friends << u unless user.friends.include? u
        end
      end
    end

    def import_user
      steam_provider.user.update_attributes({ :name => steam_provider.name })
    end

    def import_location
      game_name = steam_provider.current_game
      puts "#{steam_provider.user.name} is in #{game_name}"
      steam_provider.user.set_game(game_name)
    end
  end
end
