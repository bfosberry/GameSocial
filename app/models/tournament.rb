require 'workers/notification_worker'

class Tournament < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :game
  has_many :game_events, ->{ order(:game_start_time) }, :dependent => :destroy
  has_many :teams, :dependent => :destroy
  has_many :tournament_rounds, :dependent => :destroy

  delegate :name, to: :game, prefix: true, allow_nil: true
  delegate :logo_url, to: :game, prefix: true, allow_nil: true
  delegate :name, to: :event, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true

  has_one :object_permission, as: :permissible_object
  accepts_nested_attributes_for :object_permission
  delegate :is_visible_to?, :to => :object_permission

  alias_attribute :start_time, :tournament_start_time

  before_save :set_defaults
  before_destroy :delete_tournament
  after_commit :export_tournament, :on => [:create, :update]

  validates :name, 
            :num_teams, 
            :team_max_size, 
            :team_min_size, 
            :games_per_round,
            :teams_per_round,
            :lead_time,
            :num_parallel_events,
            :time_between_rounds,
            :round_length, :presence => true

  TIME_ROUNDING_OPTIONS = ["None", "5 Minute", "10 Minute", "15 Minute", "30 Minute", "60 Minute"]

  #validates :time_rounding, :inclusion => {:in => TIME_ROUNDING_OPTIONS}

  default_scope { order(created_at: :asc) }

  def self.time_rounding_options
    TIME_ROUNDING_OPTIONS
  end

  def next_event
    game_events.where("game_start_time > ?", DateTime.now).first
  end

  def in_team?(user)
    !team_for(user).nil?
  end

  def team_for(user)
    teams.select {|t| t.users.include? user }.first
  end

  def can_create_team?(user)
    public_teams && team_for(user).nil?
  end

  def end_time
    game_events.last.try(:end_time) || start_time + 60.minutes
  end

  def formatted_start_time
    start_time.to_formatted_s(:long_ordinal) if start_time
  end

  def formatted_end_time
    end_time.to_formatted_s(:long_ordinal) if end_time
  end

  def set_defaults
    self.start_time ||= DateTime.now.beginning_of_minute
  end

  def lock
    return if locked?
    update_attribute(:locked, true)
    build_rounds
    initialize_teams
    schedule_rounds
    update_rounds
    save
  end

  def build_rounds
    return unless locked?
    numBrackets = Math.log(teams.size, teams_per_round).ceil
    for bracket in 1..numBrackets
      num_rounds_in_bracket = (teams.size.to_f/(teams_per_round ** bracket)).ceil
      teams_in_round = teams.size.to_f/(teams_per_round ** (bracket-1)).ceil

      for round in 0..(num_rounds_in_bracket-1)
        tr = tournament_rounds.where({ :bracket_id => bracket, :round_index => round}).first_or_create
        if round == num_rounds_in_bracket - 1
          tr.num_teams = (num_rounds_in_bracket * teams_per_round) - teams_in_round
        else
          tr.num_teams = teams_per_round
        end 
        tr.save
      end
    end
  end

  def locked?
    locked
  end

  def initialize_teams
    return unless locked?
    tournament_rounds.where(:bracket_id => 1).each do |tr|
      unless tr.winner
        tr.teams = teams.limit(teams_per_round).offset(tr.round_index * teams_per_round)
        tr.save
      end
    end
  end

  def schedule_rounds
    time = (start_time || DateTime.now) + lead_time.minutes
    in_slot = 0
    bracket = 1

    tournament_rounds.each do |tr|
      if (in_slot >= (num_parallel_events)) || (bracket != tr.bracket_id)
        time = time + round_length.minutes + time_between_rounds.minutes
        in_slot = 0
      end
      start_time = time
      end_time = time + round_length.minutes

      bracket = tr.bracket_id

      in_slot = in_slot + 1
      title = "Tournament: #{name}, Bracket #{tr.bracket_id}, Round #{tr.round_index + 1}"
      game_event = GameEvent.create(:tournament => self,
                                    :game_start_time => start_time,
                                    :game_end_time => end_time,
                                    :user => user,
                                    :event => event,
                                    :game => game,
                                    :title => title)
      op = ObjectPermission.create(:permissible_object_id => game_event.id,
                                   :permissible_object_type => game_event.class.name,
                                   :permission_type => self.object_permission.permission_type) 
      game_event.object_permission = op
      game_event.save

      tr.reload
      tr.game_event_id = game_event.id
      tr.save
    end
  end

  def update_rounds(tournament_round=nil)
    if tournament_round
      winner = tournament_round.winner
      if winner
        next_bracket = tournament_round.bracket_id + 1
        next_round_index = (tournament_round.round_index.to_f/2).floor
        next_round = tournament_rounds
          .where('bracket_id = ?', next_bracket)
          .where('round_index = ?', next_round_index).first
        if next_round
          unless next_round.teams.include? winner
            next_round.teams.append(winner)
          end
          next_round.save
        end
      end
    end

    tournament_rounds.each do |tr|
      if tr.game_event
        tr.game_event.users = tr.teams.flat_map {|t| t.users }
        team_names = tr.teams.map {|t| t.name }
        unless team_names.empty?
          tr.game_event.update_attribute(:description, "#{game_name} tournament. #{team_names.join(" vs ")}")
        end
        tr.game_event.export_game_event
      end
    end                     
  end

  def winner
    tournament_rounds.last.try(&:winner)
  end

  def winner_name
    winner.name
  end

  def notify
    users.each{|u| Workers::NotificationWorker.perform_async(u.id, notification_title)}
  end

  def users
    teams.flat_map {|t| t.users }.uniq
  end

  def notification_title
    "Tournament #{name} was updated."
  end

  def export_tournament
    if calendar.event
      calendar.update_event
    else
      calendar.create_event
    end
  end

  def delete_tournament
    calendar.delete_event
  end

  def calendar
    @calendar ||= Calendar.new(self)
  end
end