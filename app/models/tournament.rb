class Tournament < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_many :game_event, :dependent => :destroy
end
