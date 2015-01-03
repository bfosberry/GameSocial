require 'calendar'

class Event < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :email, :to => :user, :prefix => true, :allow_nil => true
  has_many :posts, as: :postable
  has_many :game_events, :dependent => :destroy
  has_one :object_permission, as: :permissible_object
  delegate :is_visible_to?, :to => :object_permission
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :object_permission

  before_save :set_defaults
  before_destroy :delete_event

  after_commit :export_event, :on => [:create, :update]

  default_scope { order(start_time: :asc) }

  validate :valid_length?
  validate :name, :presence => true

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

  def calendar
    @calendar ||= Calendar.new(self)
  end
end
