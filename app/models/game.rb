class Game < ActiveRecord::Base
  has_and_belongs_to_many :users

  default_scope order('name ASC')

  scope :board, -> { where(provider: "board")}
  scope :steam, -> { where(provider: "steam")}

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

