class GameEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :event
  belongs_to :game_social_server
  belongs_to :chat_server

  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
  delegate :title, :to => :event, :prefix => true, :allow_nil => true
  delegate :name, :to => :game_social_server, :prefix => true, :allow_nil => true
  delegate :name, :to => :chat_server, :prefix => true, :allow_nil => true
end
