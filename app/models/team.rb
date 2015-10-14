class Team < ActiveRecord::Base
	belongs_to :user
	belongs_to :tournament
	has_many :team_members
	has_many :users, through: :team_members

    delegate :name, to: :tournament, prefix: true, allow_nil: true
    delegate :name, to: :user, prefix: true, allow_nil: true

	has_one :object_permission, as: :permissible_object
    accepts_nested_attributes_for :object_permission
    delegate :is_visible_to?, :to => :object_permission

    def can_join?(user)
        is_visible_to?(user)
    end
end
