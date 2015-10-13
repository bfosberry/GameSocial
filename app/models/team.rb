class Team < ActiveRecord::Base
	belongs_to :user
	belongs_to :tournament
	has_many :team_members
	has_many :users, through: :team_members
end
