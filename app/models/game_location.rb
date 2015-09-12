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
    user.alert(self) if game
  end

  def location_title
    if game
      "Your friend #{user_name} is playing #{game_name}"
    else
      "#{user_name} is not in-game"
    end
  end

  def location_body
    if game
      "<p>Looks like your friend #{user_name} is playing #{game_name}!</p>#{game_server_body}#{chat_server_body}"
    else
      "<p>#{user_name} is currently not playing any games</p>"
    end
  end

  def game_server_body
    "<p>You can join them on this game server: <a href='#{game_social_server.launch_url}'>Join #{game_social_server_name}</a></p>" if game_social_server
  end

  def chat_server_body
    "<p>If you want to chat with them, they're on this chat server: #{chat_server_name}</p>" if chat_server
  end

  def delete_alerts
    #messy delete for now
    alerts = Alert.all.select {|a| a.payload == self }
    alerts.each {|a| a.destroy }
  end

  def self.update_location(location, user, game, game_server, chat_server)
    if location == nil || location.game != game
      location = GameLocation.create({ :user => user,
                                       :game => game,
                                       :game_social_server => game_server,
                                       :chat_server => chat_server })
    else
      location.game_social_server = game_server
      location.chat_server = chat_server
      location.save
    end
  end

  def self.in_game
    where('game_id IS NOT NULL')
  end
end
