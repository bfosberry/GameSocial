class User < ActiveRecord::Base

  has_many :chat_servers
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
	has_and_belongs_to_many :games
end
