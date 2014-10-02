class GameSocialServer < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  validates :name, :game, :presence => true

  before_validation :import_server

  def import_server
    server = SourceServer.new(ip, port)
    info = server.server_info
    self.name = info[:server_name]
    self.max_players = info[:max_players]
    self.current_players = info[:number_of_players]
    gid = info[:game_id]
    self.game = Game.where(:provider_id => gid).first
    self.current_map = info[:map_name]
    self.match_type = info[:game_description]
    self.latency = server.ping
  rescue;
  end
end
