class GameLocation < ActiveRecord::Base
  belongs_to :game
  belongs_to :game_server
  belongs_to :chat_server
  belongs_to :user

  after_create :alert_user

  def alert_user
  	user.alert(self)
  end
end
