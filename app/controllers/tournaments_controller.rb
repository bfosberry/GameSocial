class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :lock, :concede, :resolve]
  before_filter :spoof_login, only: [:show, :index]
  before_filter :enforce_login, only: [:new, :edit, :update, :destroy, :resolve, :concede]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = all_visible(Tournament)
    @tournaments_grid = initialize_grid(@tournaments,
                                        :include => [:user, :event])
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    enforce_visibility(@tournament)
    @tournament_rounds_grid = initialize_grid(@tournament.tournament_rounds, 
                                              :include => [:game_event])
    @teams_grid = initialize_grid(@tournament.teams,
                                  :include => [:user])
  end

  # GET /tournaments/1/lock
  # GET /tournaments/1/lock.json
  def lock
    enforce_ownership(@tournament)
    @tournament.notify
    @tournament.lock
    redirect_to @tournament
  end

  # GET /tournaments/1/brackets/2/concede
  # GET /tournaments/1/brackets/2/concede.json
  def concede
    team = @tournament.team_for(current_user)
    enforce_ownership(team)
    tournament_rounds = @tournament.tournament_rounds.where('bracket_id = ?', params['bracket_id'])
    if team 
      round = tournament_rounds.select { |tr| tr.teams.include? team }.first
      if round
        if round.winner.nil?
          @tournament.notify
          round.concede(team)
          notice = "Round conceded"
        else
          notice = "Round already resolved"
        end
      else
        notice = "No round to concede"
      end
    else
      notice = "Not in team"
    end
    redirect_to @tournament, notice: notice
  end

  # POST /tournaments/1/brackets/2/resolve
  # POST /tournaments/1/brackets/2/resolve.json
  def resolve
    enforce_ownership(@tournament)
    team = Team.find(params[:team_id])
    tournament_rounds = @tournament.tournament_rounds.where('bracket_id = ?', params['bracket_id'])
    if team 
      round = tournament_rounds.select { |tr| tr.teams.include? team }.first
      if round
        @tournament.notify
        round.resolve(team)
        notice = 'Round resolved'
      else
        notice = "No round to resolve"
      end
    else
      notice = "No team found"
    end
    redirect_to @tournament, notice: notice
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
    @tournament.object_permission = ObjectPermission.new
  end

  # GET /tournaments/new_for_event
  def new_for_event
    @tournament = Tournament.new({ :event_id => params[:event_id]})
    @tournament.object_permission = ObjectPermission.new
    render 'new'
  end

  # GET /tournaments/1/edit
  def edit
    enforce_ownership(@tournament)
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.user = current_user unless @tournament.user

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tournament }
      else
        format.html { render action: 'new' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    enforce_ownership(@tournament)
    respond_to do |format|
      @tournament.notify
      if @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    enforce_ownership(@tournament)
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :game_id, :event_id, :description, :num_teams, :team_max_size, :team_min_size, :games_per_round, :teams_per_round, :brackets, :public_teams, :lead_time, :num_parallel_events, :time_between_rounds, :time_rounding, :event_earliest_time, :event_latest_time, :round_length, object_permission_attributes: [:permission_type])
    end
end
