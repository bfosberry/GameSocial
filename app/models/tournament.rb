class Tournament < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :game
  has_many :game_events, :dependent => :destroy
  has_many :teams, :dependent => :destroy
  has_many :tournament_rounds, :dependent => :destroy

  delegate :name, to: :game, prefix: true, allow_nil: true
  delegate :name, to: :event, prefix: true, allow_nil: true

  has_one :object_permission, as: :permissible_object
  accepts_nested_attributes_for :object_permission
  delegate :is_visible_to?, :to => :object_permission

  TIME_ROUNDING_OPTIONS = %w(None, 5 Minute, 10 Minute, 15 Minute, 30 Minute, 60 Minute)

  validates :time_rounding, :inclusion => {:in => TIME_ROUNDING_OPTIONS}

  default_scope { order(created_at: :asc) }

  def self.time_rounding_options
    TIME_ROUNDING_OPTIONS
  end

  def next_event
    game_events.where("game_start_time > ?", DateTime.now).first
  end

  def in_team?(user)
    !team_for(user).nil?
  end

  def team_for(user)
    teams.select {|t| t.users.include? user }.first
  end

  def can_create_team?(user)
    public_teams
  end

  def build_rounds
  end
end
