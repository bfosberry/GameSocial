class GameSocialServer < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_one :object_permission, as: :permissible_object
  accepts_nested_attributes_for :object_permission
  delegate :is_visible_to?, :to => :object_permission

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  validates :name, :game, :ip, :port, :presence => true

  before_validation :import_server

  GAME_SERVER_EXPIRY = 5.minutes

  def import_server
    info = server_info
    unless info.empty?
      self.name = info[:server_name]
      self.max_players = info[:max_players]
      self.current_players = info[:number_of_players]
      gid = info[:game_id]
      self.game = Game.where(:provider_id => gid).first if gid
      self.current_map = info[:map_name]
      self.match_type = info[:game_description]
    end
  end

  def launch_url
    "steam://connect/#{ip}:#{port}"
  end

  def game_server_cache_key(ip, port)
    "steam_game_server_#{ip}:#{port}"
  end

  def server_info
    Rails.cache.fetch(game_server_cache_key(ip, port), :expires_in => GAME_SERVER_EXPIRY) do
      begin
        server = SteamCondenser::Servers::SourceServer.new(ip, port)
        server.server_info
      rescue;
        {}
      end
    end
  end
end
