class User < ActiveRecord::Base
	has_and_belongs_to_many :games

	create! do |user|
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.name = auth["info"]["name"]
  end
end
