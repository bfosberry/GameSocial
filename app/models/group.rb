class Group < ActiveRecord::Base
  belongs_to :user
  delegate :name, :to => :user, :prefix => true, :allow_nil => true
  has_one :object_permission, as: :permissible_object
  accepts_nested_attributes_for :object_permission
  validate :name, :presence => true  

  has_and_belongs_to_many :users
end
