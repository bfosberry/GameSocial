class TournamentRound < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game_event
  serialize :score, Hash

  belongs_to :winner, foreign_key: "winner_id", class_name: "Team"
end

