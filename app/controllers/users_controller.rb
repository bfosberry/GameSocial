class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :add_game]
  skip_before_filter :verify_authenticity_token  
  before_filter :enforce_login, :except => [:new, :create, :home]
  before_filter :enforce_admin, :only => [:index]

  autocomplete :user, :name

  # GET /users
  # GET /users.json
  def index
    @users_grid = initialize_grid(User)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @game = Game.new
    @games_grid = initialize_grid(@user.games, :per_page => 10)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # GET /users/home
  def home
    if current_user
      @game_events_grid = initialize_grid(current_user.upcoming_game_events, :include => [:game])
      if current_user.email.blank?
       flash[:notice] = "Your email address is not set, please set it #{view_context.link_to('here',edit_user_path(current_user))}".html_safe

      end
    end
  end

  # POST /user/1/games
  def add_game
    game = Game.find(game_params[:id])
    @user.games << game unless @user.games.include?(game)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Game was successfully added.' }
        format.json { render action: 'show', status: :ok, location: @user }
      else
        format.html { redirect_to @user, notice: 'Failed to add Game.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #update all users events and game events to re-export
    respond_to do |format|
      up = user_params
      up[:games] = up[:game_ids].reject {|g|  g.blank? }.map {|id| Game.find(id) } if up[:game_ids]
      up[:friends] = up[:friend_ids].reject {|f|  f.blank? }.map {|id| User.find(id) } if up[:friend_ids]
      
      if @user.update(up)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /users/sync
  def sync
    w = Workers::SyncWorker.new
    w.perform(current_user.id)
    redirect_to root_path, notice: "Users synced"
  end

  # GET /users/sync_location
  def sync_location
    current_user.friends.each do |u|
      w = Workers::LocationSyncWorker.new
      w.perform(u.id)
    end
    w = Workers::LocationSyncWorker.new
    w.perform(current_user.id)
    redirect_to root_path, notice: "Locations synced"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      enforce_ownership(@user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:provider, :uid, :name, :email, :game_ids =>[])
    end

    def game_params
      params.require(:game).permit(:id)
    end
end
