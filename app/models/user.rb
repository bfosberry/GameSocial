require 'workers/sync_worker'
require 'workers/location_sync_worker'
require 'workers/import_worker'
class User < ActiveRecord::Base
  has_many :chat_servers
  has_and_belongs_to_many :games
  has_many :game_events
  has_many :events
  has_and_belongs_to_many :attending_events, class_name: "Event"
  has_and_belongs_to_many :attending_game_events, class_name: "GameEvent"

  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :game_locations, :dependent => :destroy
  has_many :alerts, :through => :alert_schedules, :order => "created_at DESC"

  has_many :alerting_users, dependent: :destroy
  has_many :alerting_schedules, through: :alerting_users, :source => :alert_schedule

  has_many :alert_schedules

#  has_secure_password
#  validates_confirmation_of :password

  before_save { |user| user.email = email.downcase if email }
  before_save :create_remember_token

  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    user.activate
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = "steam"
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
      user.status = "Active"
    end
  end
 
  def sanatized_name
    name.blank? ? "(Unknown)" : name
  end

  def add_as_friend(user)
    user.friends.add(user)
  end

  def latest_location
    game_locations.last
  end

  def latest_locations
    friends.map {|f| f.latest_location }.select {|l| l && l.game }
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
    Workers::SyncWorker.perform_async(self.id)
  end

  def import
    Workers::ImportWorker.perform_async(self.id)
  end

  def refresh_location
    Workers::LocationSyncWorker.perform_async(self.id)
  end

  def alert(game_location)
    alerting_schedules.each {|as| as.alert(game_location)}
  end

  def set_game(game_name)
    game = Game.where({:name => game_name}).first
    location = game_locations.last
    GameLocation.update_location(location, self, game, nil, nil)
  end

  def join_event(event)
    attending_events << event unless attending_event?(event)
  end

  def leave_event(event)
    attending_events.delete(event) if attending_event?(event)
  end
  
  def attending_event?(event)
    attending_events.include?(event)
  end

  def join_game_event(game_event)
    attending_game_events << game_event unless attending_game_event?(game_event)
  end

  def leave_game_event(game_event)
    attending_game_events.delete(game_event) if attending_game_event?(game_event)
  end

  def attending_game_event?(game_event)
    attending_game_events.include?(game_event)
  end
 
  def is_active?
    status == "Active"
  end
 
  def activate
    self.update_attribute(:status, "Active") unless is_active?
  end
  
  private
    def create_remember_token
      if self.remember_token.blank? or self.password_digest_changed?
        self.remember_token = SecureRandom.urlsafe_base64
      end
    end
end
