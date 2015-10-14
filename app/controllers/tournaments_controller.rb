class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]
  before_filter :spoof_login, only: [:show, :index]
  before_filter :enforce_login, only: [:new, :edit, :update, :destroy]

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
    @game_events = all_visible(GameEvent).where("tournament_id = ?", @tournament.id)
    @game_events_grid = initialize_grid(@game_events, :include => [:game])
    @teams_grid = initialize_grid(@tournament.teams,
                                  :include => [:user])
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
      params.require(:tournament).permit(:name, :game_id, :event_id, :description, :num_teams, :team_max_size, :team_min_size, :games_per_round, :teams_per_round, :brackets, :public_teams, :lead_time, :num_parallel_events, :time_between_rounds, :time_rounding, :event_earliest_time, :event_latest_time, object_permission_attributes: [:permission_type])
    end
end
