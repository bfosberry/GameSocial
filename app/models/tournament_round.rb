class TournamentRound < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game_event
  serialize :score, Hash
end

