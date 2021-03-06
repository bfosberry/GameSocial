class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :join, :leave, :send_invite]
  before_filter :enforce_login

  # GET /teams
  # GET /teams.json
  def index
    @teams = all_visible(Team)
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @invite = Invite.new
    enforce_visibility(@team)
  end

  # GET /teams/new
  def new
    @team = Team.new(user: current_user)
    @team.object_permission = ObjectPermission.new
  end

  # GET /teams/:id/join
  def join
    enforce_visibility(@team)
    @team.users.append(current_user) unless @team.users.include?(current_user)
    redirect_to return_url, notice: 'Team joined.'
  end

  # GET /teams/:id/leave
  def leave
    enforce_visibility(@team)
    @team.users.delete(current_user) if @team.users.include?(current_user)
    redirect_to return_url, notice: 'Team left.'
  end

  # GET /teams/new_for_tournament
  def new_for_tournament
    tournament = Tournament.find(params[:tournament_id])
    enforce_visibility(tournament)
    @team = Team.new(tournament: tournament, user: current_user)
    @team.object_permission = ObjectPermission.new
    render 'new'
  end

  # GET /teams/1/edit
  def edit
    enforce_ownership(@team)
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)
    @team.user = current_user
    respond_to do |format|
      if @team.save
        @team.users << current_user
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render action: 'show', status: :created, location: @team }
      else
        format.html { render action: 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    enforce_ownership(@team)
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    enforce_ownership(@team)
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end

  # GET /events/1/invite
  def invite
    enforce_visibility(@team)
    @invite = Invite.new
  end

  # POST /events/1/invite
  def send_invite
    enforce_visibility(@team)
    @invite = Invite.new(invite_params)
    @invite.team= @team
    @invite.user = current_user
    @invite.deliver
    redirect_to tournament_path(@team.tournament), notice: "Invite sent"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:tournament_id, :user_id, :name, object_permission_attributes: [:permission_type])
    end

    def invite_params
      params.require(:invite).permit(:email)
    end

    def return_url
      request.referrer || tournament_path(@team.tournament)
    end
end
