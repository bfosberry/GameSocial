class TournamentRound < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :game_event, :dependent => :destroy
  serialize :score, Hash
  serialize :conceded, Array
  has_and_belongs_to_many :teams

  delegate :title, to: :game_event, allow_nil: true, prefix: true
  delegate :game_start_time, to: :game_event, allow_nil: true
  delegate :game_end_time, to: :game_event, allow_nil: true
  delegate :name, to: :winner, allow_nil: true, prefix: true

  belongs_to :winner, foreign_key: "winner_id", class_name: "Team"

  def status
  	if winner
  		return "Completed"
  	elsif game_event.nil?
        return "Unscheduled"
  	elsif teams.empty? 
        return "Pending"
  	elsif game_start_time < DateTime.now
        return "In Progress"
    else 
    	return "Upcoming"
  	end
  end
end

