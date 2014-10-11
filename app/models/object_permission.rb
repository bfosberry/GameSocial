class ObjectPermission < ActiveRecord::Base
	has_and_belongs_to_many :users
	belongs_to :permissible_object, :polymorphic => true

	def self.permission_types
	  ["Public", "Private", "Group"]
	end
end
