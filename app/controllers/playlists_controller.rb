class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy, :add_game, :delete_game]
  skip_before_filter :verify_authenticity_token
  before_filter :enforce_login
  before_filter :enforce_admin, except: [:create, :delete, :add_game, :delete_game]

  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
  end

  # GET /playlists/new
  def new
    session[:return_to] = request.referrer
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists/1
  def add_game
    enforce_ownership(@playlist)
    g = Game.find(params[:game_id])
    @playlist.games << g
    respond_to do |format|
      format.html { redirect_to request.referrer, notice: "Added #{g.name} to playlist." }
      format.json { render action: 'show', status: :created, location: @playlist }
    end
  end

  # DELETE /playlists/1/2
  def delete_game
    enforce_ownership(@playlist)
    g = Game.find(params[:game_id])
    @playlist.games.delete(g)
    respond_to do |format|
      format.html { redirect_to request.referrer, notice: "Removed #{g.name} from playlist." }
      format.json { render action: 'show', status: :created, location: @playlist }
    end
  end

  # POST /playlists
  # POST /playlists.json
  def create
    @playlist = Playlist.new(playlist_params)

    respond_to do |format|
      if @playlist.save
        return_url = session.delete(:return_to) || playlists_path
        format.html { redirect_to return_url, notice: 'Playlist was successfully created.' }
        format.json { render action: 'show', status: :created, location: @playlist }
      else
        format.html { render action: 'new' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  def update
    enforce_ownership(@event)
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    enforce_ownership(@event)
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params[:playlist]
    end
end
