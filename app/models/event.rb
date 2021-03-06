require 'calendar'
require 'workers/notification_worker'

class Event < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :email, :to => :user, :prefix => true, :allow_nil => true
  has_many :posts, as: :postable
  has_many :playlists
  has_many :game_events, ->{ order(:game_start_time) }, :dependent => :destroy
  has_many :tournaments, :dependent => :destroy
  has_and_belongs_to_many :game_social_servers
  has_one :object_permission, as: :permissible_object
  delegate :is_visible_to?, :to => :object_permission
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :object_permission

  before_save :set_defaults
  before_destroy :delete_event

  after_commit :export_event, :on => [:create, :update]

  default_scope { order(start_time: :asc) }

  validate :valid_length?
  validates :name, :presence => true

  def valid_length?
    if start_time >= end_time
      errors.add(:end_time, 'must occur after start_time')
    end
  end

  def export_event
    if calendar.event
      calendar.update_event
    else
      calendar.create_event
    end
  end

  def delete_event
    calendar.delete_event
  end

  def next_event
    next_ge = game_events.where("game_start_time > ?", DateTime.now).first
    next_t = tournaments.where("tournament_start_time > ?", DateTime.now).first
    return next_ge unless next_t
    return next_t unless next_ge
    return (next_t.start_time < next_ge.start_time) ? next_t : next_ge
  end

  def set_defaults
    self.start_time ||= DateTime.now.beginning_of_minute
    self.end_time ||= DateTime.now.beginning_of_minute
  end

  def formatted_start_time
    start_time.to_formatted_s(:long_ordinal) if start_time
  end

  def formatted_end_time
    end_time.to_formatted_s(:long_ordinal) if end_time
  end

  def popular_games
    popularity = {}
    game_events.each do |ge|
      popularity[ge.game] = [] unless popularity[ge.game]
      popularity[ge.game].concat(ge.users.to_a)
    end

    playlists.each do |p|
      p.games.each do |g|
        popularity[g] = [] unless popularity[g]
        popularity[g].append(p.user)
      end
    end

    games = []
    popularity.each {|k,v| games.append({ game: k, users: v.sort.uniq}) if v.size > 0}
    games.sort_by {|g| -g[:users].size }
  end

  def calendar
    @calendar ||= Calendar.new(self)
  end

  def notify
    users.each {|u| Workers::NotificationWorker.perform_async(u.id, notification_title) }
  end

  def notification_title
    "Lan Party #{name} was updated."
  end
end
