class GameLocationsController < ApplicationController
  before_action :set_game_location, only: [:show, :edit, :update, :destroy]

  # GET /game_locations
  # GET /game_locations.json
  def index
    @game_locations = GameLocation.all
  end

  # GET /game_locations/1
  # GET /game_locations/1.json
  def show
  end

  # GET /game_locations/new
  def new
    @game_location = GameLocation.new
  end

  # GET /game_locations/1/edit
  def edit
  end

  # POST /game_locations
  # POST /game_locations.json
  def create
    @game_location = GameLocation.new(game_location_params)

    respond_to do |format|
      if @game_location.save
        format.html { redirect_to @game_location, notice: 'Game location was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game_location }
      else
        format.html { render action: 'new' }
        format.json { render json: @game_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_locations/1
  # PATCH/PUT /game_locations/1.json
  def update
    respond_to do |format|
      if @game_location.update(game_location_params)
        format.html { redirect_to @game_location, notice: 'Game location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_locations/1
  # DELETE /game_locations/1.json
  def destroy
    @game_location.destroy
    respond_to do |format|
      format.html { redirect_to game_locations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_location
      @game_location = GameLocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_location_params
      params.require(:game_location).permit(:user_id, :game_id, :game_server_id, :chat_server_id)
    end
end
