require "addressable/uri"
class ChatServer < ActiveRecord::Base
  attr_accessor :username
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  has_one :object_permission, as: :permissible_object
  accepts_nested_attributes_for :object_permission
  delegate :is_visible_to?, :to => :object_permission

  validate :name, :ip, :port, :presence => true
  
  SERVER_TYPES =  ["Teamspeak", "Mumble", "Ventrilo", "Discord"]

   def self.server_types
    SERVER_TYPES
  end

  def launch_url(user)
    return url unless url.blank?
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
    elsif server_type == "Mumble"
      pw_string = password.blank? ? "" : ":#{password}"
      login_string = pw_string.blank? ? user.name : "#{user.name}:#{pw_string}"
      "mumble://#{login_string}@#{ip}:#{port}/#{room}"
    elsif server_type == "Ventrilo"
      uri = Addressable::URI.new
      options = {}
      options[:servername] = name
      options[:serverpassword] = password unless password.blank?
      options[:channelname] = room unless room.blank?
      options[:channelpassword] = room_password unless room_password.blank?
      uri.query_values = options
      "ventrilo://#{ip}:#{port}/#{uri.query}"
    end
  end
end
