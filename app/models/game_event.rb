class GameEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :event
  belongs_to :game_social_server
  belongs_to :chat_server
  has_many :posts, as: :postable
  has_and_belongs_to_many :users

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  delegate :name, :to => :event, :prefix => true, :allow_nil => true
  delegate :name, :to => :game_social_server, :prefix => true, :allow_nil => true
  delegate :name, :to => :chat_server, :prefix => true, :allow_nil => true

  default_scope order('start_time ASC')
  def name
    title
  end

  def location
    game_social_server_name
  end
end
