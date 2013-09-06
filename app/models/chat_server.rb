class ChatServer < ActiveRecord::Base
  validates :username, :exclusion => { :in => server_types } 
  def self.server_types
  	["Teamspeak", "Mumble", "Ventrillo"]
  end
end
