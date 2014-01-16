class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  delegate :name, :to => :friend, :prefix => true, :allow_nil => true
end
