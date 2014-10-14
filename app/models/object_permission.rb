class ObjectPermission < ActiveRecord::Base
	has_and_belongs_to_many :users
	belongs_to :permissible_object, :polymorphic => true

	def self.permission_types
	  group_permission_types << "Group"
	end

	def self.group_permission_types
      ["Public", "Private"]
    end
end
