class GameEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :event
  belongs_to :game_social_server
  belongs_to :chat_server

  delegates :name, :to => :user, :prefix => true, :allow_nil => true
  delegates :name, :to => :game, :prefix => true, :allow_nil => true
  delegates :title, :to => :event, :prefix => true, :allow_nil => true
  delegates :name, :to => :game_social_server, :prefix => true, :allow_nil => true
  delegates :name, :to => :chat_server, :prefix => true, :allow_nil => true
end
