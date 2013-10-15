require 'workers/sync_worker'
class User < ActiveRecord::Base
  has_many :chat_servers
  has_and_belongs_to_many :games
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :game_locations

  has_many :alerting_users, dependent: :destroy
  has_many :alerting_schedules, through: :alerting_users, :source => :alert_schedule

  has_many :alert_schedules

  has_secure_password
  validates_confirmation_of :password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = "steam"
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

  def add_as_friend(user)
    user.friends.add(user)
  end

  def latest_location
    game_locations.last
  end

  def is_admin?
    admin
  end

  def has_friend?(user)
    friends.include?(user)
  end
 
  def get_friendship(user)
    Friendship.find_by_user_id_and_friend_id(user.id, self.id) || Friendship.find_by_user_id_and_friend_id(self.id, user.id)
  end

  def refresh_data
    w = Workers::SyncWorker.new
    w.perform(self.id)
  end

  def alert(game_location)
    alerting_schedules.each {|as| as.alert(game_location)}
  end

  def alerts
    alert_schedules.map {|as| as.alerts }.flatten
  end

  def set_game(game_name)
    game = Game.where({:name => game_name}).first
    location = game_locations.last
    GameLocation.update_location(location, self, game, nil, nil)
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
