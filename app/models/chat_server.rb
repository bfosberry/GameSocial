require "addressable/uri"
class ChatServer < ActiveRecord::Base
  attr_accessor :username
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  has_one :object_permission, as: :permissible_object
  accepts_nested_attributes_for :object_permission
  delegate :is_visible_to?, :to => :object_permission

  validates :username, :exclusion => { :in => ["Teamspeak", "Mumble", "Ventrillo"] } 
  validate :name, :presence => true
  
  def self.server_types
  	["Teamspeak", "Mumble", "Ventrillo"]
  end

  def launch_url(user)
    if server_type == "Teamspeak"
      uri = Addressable::URI.new
      options = {}
      options[:port] = port
      options[:nickname] = user.name
      options[:password] = password unless password.blank?
      options[:channel] = room unless room.blank?
      options[:channelpassword] = room_password unless room_password.blank?
      uri.query_values = options
      "ts3server://#{ip}?#{uri.query}"
    end
  end
end
