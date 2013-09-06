class ChatServer < ActiveRecord::Base
  validates :username, :exclusion => { :in => ["Teamspeak", "Mumble", "Ventrillo"] } 
  belongs_to :user
  def self.server_types
  	["Teamspeak", "Mumble", "Ventrillo"]
  end
end
