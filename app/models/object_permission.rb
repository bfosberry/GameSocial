class ObjectPermission < ActiveRecord::Base
	has_and_belongs_to_many :users
	belongs_to :permissible_object, :polymorphic => true

	def self.permission_types
	  ["Public", "Friends"]
	end

	def self.event_permission_types
    permission_types << [ "Friends + Invites"]
  end
  
  def is_visible_to?(user)
    return true if user && user.is_admin?
    case permission_type
    when "Public"
    	true
    when "Friends"
    	are_friends?(user, permissible_object.user)
    when "Friends + Invites"
    	return true if are_friends?(user, permissible_object.user)
      return has_friend_in?(user, permissible_object)
    else
    	false
    end
  end

  def has_friend_in?(user, object)
    return false unless user && owner
    !(user.friends & get_user_list(object)).empty?
  end

  def get_user_list(object)
  	if object.respond_to?(:users)
      object.users
    else 
      []
    end
  end

  def are_friends?(user, owner)
    return false unless user && owner
  	user.has_friend?(owner)
  end
end
