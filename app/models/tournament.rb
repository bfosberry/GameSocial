class Tournament < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :game
  has_many :game_events, :dependent => :destroy

  delegate :name, to: :game, prefix: true, allow_nil: true
  delegate :name, to: :event, prefix: true, allow_nil: true

  has_one :object_permission, as: :permissible_object
  accepts_nested_attributes_for :object_permission
  delegate :is_visible_to?, :to => :object_permission

  TIME_ROUNDING_OPTIONS = %w(None, 5 Minute, 10 Minute, 15 Minute, 30 Minute, 60 Minute)

  validates :time_rounding, :inclusion => {:in => TIME_ROUNDING_OPTIONS}

  def self.time_rounding_options
    TIME_ROUNDING_OPTIONS
  end
end
