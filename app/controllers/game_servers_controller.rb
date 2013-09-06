class GameServersController < ApplicationController
  before_action :set_game_server, only: [:show, :edit, :update, :destroy]

  # GET /game_servers
  # GET /game_servers.json
  def index
    @game_servers = GameServer.all
  end

  # GET /game_servers/1
  # GET /game_servers/1.json
  def show
  end

  # GET /game_servers/new
  def new
    @game_server = GameServer.new
  end

  # GET /game_servers/1/edit
  def edit
  end

  # POST /game_servers
  # POST /game_servers.json
  def create
    @game_server = GameServer.new(game_server_params)

    respond_to do |format|
      if @game_server.save
        format.html { redirect_to @game_server, notice: 'Game server was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game_server }
      else
        format.html { render action: 'new' }
        format.json { render json: @game_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_servers/1
  # PATCH/PUT /game_servers/1.json
  def update
    respond_to do |format|
      if @game_server.update(game_server_params)
        format.html { redirect_to @game_server, notice: 'Game server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_servers/1
  # DELETE /game_servers/1.json
  def destroy
    @game_server.destroy
    respond_to do |format|
      format.html { redirect_to game_servers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_server
      @game_server = GameServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_server_params
      params.require(:game_server).permit(:name, :ip, :port, :game_id, :max_players, :current_players, :latency, :current_map, :match_type, :region, :user_id)
    end
end
