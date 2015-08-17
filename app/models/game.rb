class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :playlists

  default_scope { order(name: :asc) }

  scope :board, -> { where(provider: "board")}
  scope :steam, -> { where(provider: "steam")}
  before_save :ensure_name_sanitized

  def self.grouped
    Game.type_fetchers.map {|f| [f.type, f.fetch.map {|g| [g.name, g.id]}]}
  end

  def self.type_fetchers(query = Game.all)
  	query.unscoped.select("provider").order("provider").distinct.map {|g| GameTypeFetcher.new(query, g.provider)}
  end

  def self.types
    type_dict.keys
  end

  def self.type_dict
    { 
      "steam"  => "Steam Games",
      "board" => "Board Games"
    }
  end

  def self.find_by_name(game_name)
    find_by(name: sanitized_name(game_name))
  end

  def self.sanitized_name(game_name)
    game_name.force_encoding('iso-8859-1').encode!('utf-8') if game_name
  end

  def ensure_name_sanitized
    name = Game.sanitized_name(name)
  end

  class GameTypeFetcher
    def initialize(query, type)
      @query = query
      @type = type
    end

    def fetch
      @query.where("provider = ?", @type)
    end

    def type
      Game.type_dict[@type]
    end
  end
end

