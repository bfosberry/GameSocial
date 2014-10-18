class Game < ActiveRecord::Base
  has_and_belongs_to_many :users

  default_scope order('name ASC')

  scope :board, -> { where(provider: "board")}
  scope :steam, -> { where(provider: "steam")}

  def self.type_fetchers
  	Game.select("provider").order("provider").distinct.map {|g| GameTypeFetcher.new(g.provider)}
  end

  def self.types
  	["steam", "board"]
  end

  class GameTypeFetcher
    def initialize(type)
      @type = type
    end

    def fetch
      Game.where("provider = ?", @type)
    end

    def type
      @type
    end
  end
end

