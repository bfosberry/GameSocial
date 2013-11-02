class Event < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  has_many :posts, as: :postable
  has_many :game_events
  has_and_belongs_to_many :users
  default_scope order('start_time ASC')
end
