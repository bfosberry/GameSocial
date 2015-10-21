require 'calendar'
require 'workers/notification_worker'

class GameEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :event
  belongs_to :tournament
  belongs_to :game_social_server
  belongs_to :chat_server
  has_many :posts, as: :postable
  has_and_belongs_to_many :users
  has_one :tournament_round
  has_one :object_permission, as: :permissible_object
  delegate :is_visible_to?, :to => :object_permission

  accepts_nested_attributes_for :object_permission

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :email, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  delegate :name, :to => :event, :prefix => true, :allow_nil => true
  delegate :name, :to => :game_social_server, :prefix => true, :allow_nil => true
  delegate :name, :to => :chat_server, :prefix => true, :allow_nil => true
  delegate :logo_url, :to => :game, :prefix => true, :allow_nil => true

  delegate :launch_url, :to => :game_social_server, :prefix => true, :allow_nil => true
  delegate :launch_url, :to => :chat_server, :prefix => true, :allow_nil => true

  before_save :set_defaults
  before_destroy :delete_game_event
  after_commit :export_game_event, :on => [:create, :update]

  default_scope { order(game_start_time: :asc) }

  validate :valid_length?
  validate :start_time, presence: true
  validate :end_time, presence: true
  validate :name, presence: true

  alias_attribute :start_time, :game_start_time
  alias_attribute :end_time, :game_end_time

  def valid_length?
    if start_time && end_time
      if start_time >= end_time
        errors.add(:end_time, 'must occur after start_time')
      end
    end
  end

  def name
    title
  end

  def location
    game_social_server_name
  end

  def export_game_event
    if calendar.event
      calendar.update_event
    else
      calendar.create_event
    end
  end

  def delete_game_event
    calendar.delete_event
  end

  def set_defaults
    self.start_time ||= DateTime.now.beginning_of_minute
    self.end_time ||= DateTime.now.beginning_of_minute
  end

  def time_until
    diff = start_time - DateTime.now
    days = (diff/(3600*24)).to_i

    hours = ((diff % (3600*24)) /3600).to_i
    mins = ((diff % 3600)/60).to_i
    sign = diff < 0 ? "-": ""
    "#{sign}#{days} days, #{hours}h #{mins}m"
  end

  def formatted_start_time
    start_time.to_formatted_s(:long_ordinal) if start_time
  end

  def formatted_end_time
    end_time.to_formatted_s(:long_ordinal) if end_time
  end

  def calendar
    @calendar ||= Calendar.new(self)
  end

  def notify
    users.each {|u| Workers::NotificationWorker.perform_async(u.id, notification_title) }
  end

  def notification_title
    "Event #{name} was updated."
  end
end
