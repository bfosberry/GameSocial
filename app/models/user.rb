require 'workers/sync_worker'
require 'workers/location_sync_worker'
require 'workers/import_worker'
class User < ActiveRecord::Base
  has_many :chat_servers
  has_and_belongs_to_many :games
  has_many :game_events
  has_many :events
  has_many :groups
  has_many :credentials, :dependent => :destroy
  has_many :playlists
  has_many :tournaments, :dependent => :destroy

  has_and_belongs_to_many :user_groups, :join_table => "groups_users", :class_name => "Group"
  has_and_belongs_to_many :attending_events, class_name: "Event"
  has_and_belongs_to_many :attending_game_events, class_name: "GameEvent"

  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :game_locations, :dependent => :destroy
  
  has_many :alerting_users, dependent: :destroy
  has_many :alerting_schedules, through: :alerting_users, :source => :alert_schedule

  has_many :alert_schedules

  has_and_belongs_to_many :object_permissions

  after_commit :update_events, :on => [:create, :update, :destroy]

  before_save { |user| user.email = email.downcase if email }
  before_save :create_remember_token

  def merge_credential(cred)
    if cred.is_steam?
      self.name = cred.nickname
      self.avatar_url = cred.image_url
    elsif cred.is_google?
      self.email = cred.email
    end
    self.credentials << cred unless self.credentials.include? cred
    save
  end

  def alerts
    alert_schedules.flat_map(&:alerts)
  end

  def update_events
    events.each {|e| e.export_event }
    game_events.each {|e| e.export_game_event }
  end

  def games_not_owned
    if games.size > 0
      Game.where("id NOT IN (?)", games.map{|g| g.id})
    else 
      Game.all
    end
  end
 
  def sanatized_name
    n = name.blank? ? "(Unknown)" : name
    n.force_encoding('iso-8859-1').encode!('utf-8')
  end

  def add_as_friend(user)
    user.friends.add(user)
  end

  def latest_location
    game_locations.order("created_at desc").first
  end

  def latest_locations
    friends.map {|f| f.latest_location }.select {|l| l && l.game }
  end

  def is_admin?
    admin
  end

  def in_group?(group)
    user_groups.include?(group)
  end

  def has_credential(provider)
    !credentials.select {|c| c.provider == provider }.empty?
  end

  def credential(provider)
    credentials.select {|c| c.provider == provider }.first
  end

  def google_refresh_token
    credential("google_oauth2").refresh_token
  end

  def steam_uid
    credential("steam").uid if credential("steam")
  end

  def owns(object)
    object.user == self || is_admin?
  end

  def ordered_alerts
    alerts.order("created_at DESC")
  end

  def has_friend?(user)
    friends.include?(user)
  end
 
  def get_friendship(user)
    Friendship.find_by_user_id_and_friend_id(user.id, self.id) || Friendship.find_by_user_id_and_friend_id(self.id, user.id)
  end

  def refresh_data
    Workers::SyncWorker.perform_async(self.id, true)
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

  def set_game(game_name, game_server_ip)
    game = Game.find_by_name(game_name)
    location = game_locations.last
    if game_server_ip 
      ip_parts = game_server_ip.split(":")
      if ip_parts.size == 2
        default_perms = ObjectPermission.new
        default_perms.permission_type = "Public"
        gs = GameSocialServer.where(ip: ip_parts.first,
                                    port: ip_parts.last.to_i).first_or_create
        gs.user = self unless gs.user
        gs.object_permission = default_perms unless gs.object_permission
        gs.save
      end
    end
    GameLocation.update_location(location, self, game, gs, nil)
  end

  def join_event(event)
    attending_events << event unless attending_event?(event)
    event.export_event
  end

  def leave_event(event)
    attending_events.delete(event) if attending_event?(event)
    event.export_event
  end

  def join_group(group)
    user_groups << group unless in_group?(group)
  end

  def leave_group(group)
    user_groups.delete(group) if in_group?(group)
  end
  
  def attending_event?(event)
    attending_events.include?(event)
  end

  def join_game_event(game_event)
    attending_game_events << game_event unless attending_game_event?(game_event)
    game_event.export_game_event
  end

  def leave_game_event(game_event)
    attending_game_events.delete(game_event) if attending_game_event?(game_event)
    game_event.export_game_event
  end

  def attending_game_event?(game_event)
    attending_game_events.include?(game_event)
  end
 
  def is_active?
    status == "Active"
  end
  
  def playlist_for(event)
    playlists.where(event_id: event.id).first || Playlist.create(user_id: id, event_id: event.id)
  end
 
  def activate
    self.update_attribute(:status, "Active") unless is_active?
  end

  def upcoming_game_events
    attending_game_events.where("game_end_time > ?", DateTime.now)
  end

  def notify_websocket(event)
    WebsocketRails["user_#{id}"].trigger("notifications", event)
  end
  
  private
    def create_remember_token
      if self.remember_token.blank? or self.password_digest_changed?
        self.remember_token = SecureRandom.urlsafe_base64
      end
    end
end
