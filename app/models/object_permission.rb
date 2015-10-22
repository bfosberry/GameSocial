class ObjectPermission < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :permissible_object, :polymorphic => true

  def self.base_permission_types
    ["Private", "Public", "Friends"]
  end

  def self.base_event_permission_types
    base_permission_types << [ "Friends + Invites"]
  end

  def self.permission_types(user)
    gs = user ? user.groups.map{ |g| g.name } : []
    gs.empty? ? base_permission_types : (base_permission_types + gs)
  end
  
  def self.event_permission_types(user)
    gs = user ? user.groups.map{ |g| g.name } : []
    gs.empty? ? base_event_permission_types : (base_event_permission_types + gs)
  end

  def is_visible_to?(user)
    return true if user && user.is_admin?
    return true  if user == permissible_object.user

    case permission_type
    when "Public"
    	true
    when "Private"
      false
    when "Friends"
    	are_friends?(user, permissible_object.user)
    when "Friends + Invites"
    	return true if are_friends?(user, permissible_object.user)
      return has_friend_in?(user, permissible_object)
    else
      return false unless user
      g = permissible_object.user.groups.where(name: permission_type).first
      g && g.users.include?(user)
    end
  end

  def has_friend_in?(user, object)
    return false unless user && object
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
