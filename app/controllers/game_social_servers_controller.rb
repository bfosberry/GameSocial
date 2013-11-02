class GameSocialServersController < ApplicationController
  before_action :set_game_social_server, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_login

  # GET /game_social_servers
  # GET /game_social_servers.json
  def index
    @game_social_servers = GameSocialServer.all
  end

  # GET /game_social_servers/1
  # GET /game_social_servers/1.json
  def show
  end

  # GET /game_social_servers/new
  def new
    @game_social_server = GameSocialServer.new
  end

  # GET /game_social_servers/1/edit
  def edit
    enforce_ownership(@game_social_server)
  end

  # POST /game_social_servers
  # POST /game_social_servers.json
  def create
    @game_social_server = GameSocialServer.new(game_social_server_params)
    @game_social_server.user = current_user unless @game_social_server.user

    respond_to do |format|
      if @game_social_server.save
        format.html { redirect_to @game_social_server, notice: 'Game server was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game_social_server }
      else
        format.html { render action: 'new' }
        format.json { render json: @game_social_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_social_servers/1
  # PATCH/PUT /game_social_servers/1.json
  def update
    enforce_ownership(@game_social_server)
    respond_to do |format|
      if @game_social_server.update(game_social_server_params)
        format.html { redirect_to @game_social_server, notice: 'Game server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game_social_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_social_servers/1
  # DELETE /game_social_servers/1.json
  def destroy
    enforce_ownership(@game_social_server)
    @game_social_server.destroy
    respond_to do |format|
      format.html { redirect_to game_social_servers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_social_server
      @game_social_server = GameSocialServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_social_server_params
      params.require(:game_social_server).permit(:name, :ip, :port, :game_id, :max_players, :current_players, :latency, :current_map, :match_type, :region, :user_id)
    end
end
