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
        u = User.find_by({
          :uid => f.id.to_s,
        })
        if u
	      user = steam_provider.user
              user.friendships.build(:friend_id => u.id)
	    end 
      end
    end

    def import_user
      steam_provider.user.update_attributes({ :name => steam_provider.name })
    end
  end
end
