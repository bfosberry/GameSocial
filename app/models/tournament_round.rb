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

  delegate :team_for, to: :tournament

  default_scope { order(bracket_id: :asc, round_index: :asc) }

  after_commit :check

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

  def concede(team)
    unless conceded.include? team.id
      update_attribute(:conceded, conceded << team.id)
    end
    check
  end

  def resolve(team)
    update_column(:winner_id, team.id)
    tournament.update_rounds(self)
  end

  private

  def check
    if winner.nil?
      if conceded.size == num_teams.to_i - 1
        team_list = teams
        unless conceded.empty?
          team_list = team_list.where('"teams".id not in (?)', conceded)
        end
        w = team_list.first
        return unless w
        update_column(:winner_id, w.id)
        tournament.update_rounds(self)
      end
    end
  end
end

