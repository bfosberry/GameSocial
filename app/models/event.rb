class Event < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :email, :to => :user, :prefix => true, :allow_nil => true
  has_many :posts, as: :postable
  has_many :game_events
  has_and_belongs_to_many :users

  before_save :set_defaults
  default_scope order('start_time ASC')

  def set_defaults
    self.start_time ||= DateTime.now
    self.end_time ||= DateTime.now
  end
end
