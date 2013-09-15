class GameSocialServer < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  delegate :name, :to => :game, :prefix => true, :allow_nil => true
end
