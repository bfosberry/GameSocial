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
          game = Game.where(
            :provider_id => k,
            :provider => "steam"
          ).first_or_create
          g = steam_provider.games[k]
          game.name = g.name
          game.store_url = g.store_url
          game.logo_url = g.logo_url
          game.description = g.name
          game.save
          user.games << game unless user.games.include?(game)
        end  
      end
      user.save
    end

    def import_friends
      steam_provider.friends.each do |f|
        begin 
          u = create_user_from_friend(f)
          if u
            user = steam_provider.user
            u.friends << user unless u.friends.include? user
            user.friends << u unless user.friends.include? u
          end
        rescue SteamCondenser::Error => e
          raise e unless e.message =~ /This user has not yet set up their Steam Community profile/
        end
      end
    end

    def import_groups
      user = steam_provider.user
      imported_groups = []
      steam_provider.groups.each do |g|
          group = Group.where(
            :provider_id => g[:id].to_s,
            :provider => "steam"
          ).first_or_initialize
          imported_groups.append(g[:id].to_s)
          group.user = user unless group.user
          perm = ObjectPermission.new
          perm.permission_type = "Public"
          group.object_permission = perm unless group.object_permission
          group.name = g[:name] if g[:name]
          group.avatar_url = g[:avatar_medium_url] if g[:avatar_medium_url]
          group.description = g[:headline] if g[:headline]
          group.save
          user.groups<< group unless user.groups.include?(group)
      end

      removed_groups  = user.groups.where(provider: "steam").where('provider_id NOT IN (?)', imported_groups)
      removed_groups.each {|g| user.groups.delete(g) }
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
    end

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
