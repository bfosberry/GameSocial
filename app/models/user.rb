class User < ActiveRecord::Base
  has_many :chat_servers
  has_and_belongs_to_many :games
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :game_locations
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

  def self.getGames(uid)
    return get('/services/rest/', 
               :query => {
                 :method => 'flickr.people.getPublicPhotos',
                 :api_key => 'api key goes here',
                :user_id => uid}
              )
  end

  def latest_location
    game_locations.last
  end

  def is_admin?
    true
  end
end
