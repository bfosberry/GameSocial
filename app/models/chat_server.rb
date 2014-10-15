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
end
