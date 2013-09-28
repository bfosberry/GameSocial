class GameLocation < ActiveRecord::Base
  belongs_to :game
  belongs_to :game_social_server
  belongs_to :chat_server
  belongs_to :user

  after_create :alert_user

  before_destroy :delete_alerts

  delegate :name, :id, :to => :game_social_server, :prefix => true, :allow_nil => true
  delegate :name, :id, :to => :chat_server, :prefix => true, :allow_nil => true
  delegate :name, :id, :to => :game, :prefix => true, :allow_nil => true
  delegate :name, :id, :to => :user, :prefix => true, :allow_nil => true

  def alert_user
  	user.alert(self)
  end

  def location_title
  	"Heads up! #{user_name} is playing #{game_name}"
  end

  def location_body
  	"""
Looks like your friend #{user_name} is playing #{game_name}!

#{game_server_body}#{chat_server_body}"""
  end

  def game_server_body
  	"You can join them on #{game_social_server_name}\n" if game_social_server
  end

  def chat_server_body
  	"If you want to chat with them, they're on #{chat_server_name}\n" if chat_server
  end

  def delete_alerts
    #messy delete for now
    alerts = Alert.all.select {|a| a.payload == self }
    alerts.each {|a| a.destroy }
  end
end
