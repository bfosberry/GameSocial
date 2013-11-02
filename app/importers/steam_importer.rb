module Importers
  class SteamImporter
    attr_accessor :steam_provider
    def initialize(steam_provider)
      self.steam_provider = steam_provider
      self
    end

    def import_games
      steam_provider.games.keys.each do |k|
        g = steam_provider.games[k]
        game = Game.find_or_create_by({
          :name => g.name,
          :store_url => g.store_url,
          :logo_url => g.logo_url,
          :description => g.name
        })
        user = steam_provider.user
        user.games << game unless user.games.include?(game)
        user.save
      end
    end

    def import_friends
      steam_provider.friends.each do |f|
        puts "Importing #{f.id}"
        u = User.find_or_create_by({ :uid => f.id.to_s, :provider => "steam" })
        u.refresh_data
        user = steam_provider.user
        u.friendships.build(:friend_id => user.id)
        user.friendships.build(:friend_id => u.id)
        u.save
        user.save
      end
    end

    def import_user
      steam_provider.user.update_attributes({ :name => steam_provider.name })
    end

    def import_location
      game_name = steam_provider.current_game
      steam_provider.user.set_game(game_name)
    end
  end
end
