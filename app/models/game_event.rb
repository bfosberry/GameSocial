class GameEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :event
  belongs_to :game_social_server
  belongs_to :chat_server
  has_many :posts, as: :postable
  has_and_belongs_to_many :users

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :email, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  delegate :name, :to => :event, :prefix => true, :allow_nil => true
  delegate :name, :to => :game_social_server, :prefix => true, :allow_nil => true
  delegate :name, :to => :chat_server, :prefix => true, :allow_nil => true

  before_save :set_defaults
  default_scope order('start_time ASC')
  def name
    title
  end

  def location
    game_social_server_name
  end

  def set_defaults
    self.start_time ||= DateTime.now
    self.end_time ||= DateTime.now
  end

  def time_until
    diff = start_time - DateTime.now
    hours = (diff/3600).to_i
    mins = ((diff % 3600)/60).to_i
    "#{hours}h #{mins}m"
  end

  def formatted_start_time
    start_time.to_formatted_s(:long_ordinal) if start_time
  end

  def formatted_end_time
    end_time.to_formatted_s(:long_ordinal) if end_time
  end
end
