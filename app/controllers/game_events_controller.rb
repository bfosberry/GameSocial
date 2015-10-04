class GameEventsController < ApplicationController
  before_action :set_game_event, only: [:show, :edit, :update, :destroy, :join, :leave, :invite, :send_invite]
  before_filter :spoof_login, only: [:index]
  before_filter :enforce_login, only:  [:edit, :update, :destroy, :join, :leave, :invite, :send_invite]
  
  # GET /game_events
  # GET /game_events.jso
  def index
    @game_events = all_visible(GameEvent)
    @filter = params["filter"]
    if @filter == "owned"
      @game_events = @game_events.where("games.id in (?)", current_user.games.map {|g| g.id })
    end
    @game_events_grid = initialize_grid(@game_events, :include => [:user, 
                                                                :game, 
                                                                :event, 
                                                                :chat_server, 
                                                                :game_social_server])
    respond_to do |format|
      format.html {}
      format.ics do
        expires_now
        render inline: Ical.ical_from_collection(@game_events).to_s
      end 
    end
  end

  # GET /game_events/1
  # GET /game_events/1.json
  def show
    enforce_visibility(@game_event)
    @post = Post.new({ :postable => @game_event })
    @posts_grid  = initialize_grid(@game_event.posts, :include => [:user])
    @invite = Invite.new
  end

  # GET /game_events/new
  def new
    @game_event = GameEvent.new
    @game_event.object_permission = ObjectPermission.new
    @game_event.game_start_time = DateTime.now
    @game_event.game_end_time = DateTime.now
  end

  # GET /game_events/new_for_event
  def new_for_event
    @game_event = GameEvent.new({ :event_id => params[:event_id]})
    @game_event.game_start_time = DateTime.now
    @game_event.game_end_time = DateTime.now
    @game_event.object_permission = ObjectPermission.new
    render 'new'
  end

  # GET /game_events/1/invite
  def invite
    @invite = Invite.new
  end

  # POST /game_events/1/invite
  def send_invite
    @invite = Invite.new(invite_params)
    @invite.game_event = @game_event
    @invite.user =  current_user
    @invite.deliver
    redirect_to game_event_path(@game_event), notice: "Invite sent"
  end

  # GET /game_events/1/edit
  def edit
    enforce_ownership(@game_event)
  end

  # GET /game_events/1/join
  def join
    user = User.find_by_id(params[:user_id]) || current_user
    enforce_ownership(user)
    user.join_game_event(@game_event)

    respond_to do |format|
      format.html { redirect_to return_url, notice: 'Game Event joined.' }
      format.js { render json: {} }
    end
  end

  # GET /game_events/1/leave
  def leave
    user = User.find_by_id(params[:user_id]) || current_user
    enforce_ownership(user)
    user.leave_game_event(@game_event)

    respond_to do |format|
      format.html { redirect_to return_url, notice: 'Game Event left.' }
      format.js { render json: {} }
    end
  end

  def return_url
    request.referrer || game_events_path
  end

  # POST /game_events
  # POST /game_events.json
  def create
    @game_event = GameEvent.new(game_event_params)
    @game_event.user = current_user unless @game_event.user
    respond_to do |format|
      if @game_event.save
        format.html { redirect_to @game_event, notice: 'Game event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game_event }
      else
        format.html { render action: 'new' }
        format.json { render json: @game_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_events/1
  # PATCH/PUT /game_events/1.json
  def update
    enforce_ownership(@game_event)
    respond_to do |format|
      if @game_event.update(game_event_params)
        format.html { redirect_to @game_event, notice: 'Game event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_events/1
  # DELETE /game_events/1.json
  def destroy
    enforce_ownership(@game_event)
    @game_event.destroy
    respond_to do |format|
      format.html { redirect_to game_events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_event
      @game_event = GameEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_event_params
      params.require(:game_event).permit(:event_id, 
                                         :title, 
                                         :description, 
                                         :game_id, 
                                         :game_social_server_id, 
                                         :chat_server_id, 
                                         :user_id, 
                                         :start_time, 
                                         :end_time,
                                         object_permission_attributes: [:permission_type])
    end

    def invite_params
      params.require(:invite).permit(:email)
    end
end
