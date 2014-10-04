require 'calendar'

class Event < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :email, :to => :user, :prefix => true, :allow_nil => true
  has_many :posts, as: :postable
  has_many :game_events
  has_and_belongs_to_many :users

  before_save :set_defaults
  before_destroy :delete_event

  after_commit :export_event, :on => [:create, :update]

  default_scope order('start_time ASC')

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
    self.start_time ||= DateTime.now
    self.end_time ||= DateTime.now
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
