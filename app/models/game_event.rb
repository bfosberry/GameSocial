require 'calendar'

class GameEvent < ActiveRecord::Base
  extend TimeSplitter::Accessors

  belongs_to :user
  belongs_to :game
  belongs_to :event
  belongs_to :game_social_server
  belongs_to :chat_server
  has_many :posts, as: :postable
  has_and_belongs_to_many :users
  has_one :object_permission, as: :permissible_object

  accepts_nested_attributes_for :object_permission

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :email, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  delegate :name, :to => :event, :prefix => true, :allow_nil => true
  delegate :name, :to => :game_social_server, :prefix => true, :allow_nil => true
  delegate :name, :to => :chat_server, :prefix => true, :allow_nil => true

  before_save :set_defaults
  before_destroy :delete_game_event
  after_commit :export_game_event, :on => [:create, :update]

  default_scope order('start_time ASC')

  validate :valid_length?

  split_accessor :start_time, :end_time

  def valid_length?
    if start_time >= end_time
      errors.add(:end_time, 'must occur after start_time')
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
    self.start_time ||= DateTime.now
    self.end_time ||= DateTime.now
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
end
