class TournamentRound < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game_event, :dependent => :destroy
  serialize :score, Hash
  has_and_belongs_to_many :teams

  belongs_to :winner, foreign_key: "winner_id", class_name: "Team"
end

