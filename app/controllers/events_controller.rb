require 'ical'

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :join, :leave, :invite, :send_invite, :game_social_servers, :delete_game_social_server]
  before_filter :spoof_login, only: [:show, :index]
  before_filter :enforce_login, except: [:index, :show]
  
  # GET /events
  # GET /events.json
  def index
    @events = all_visible(Event)
    @events_grid = initialize_grid(@events,
                                   :include => [:user])
    respond_to do |format|
      format.html {}
      format.ics do
        expires_now
        render inline: Ical.ical_from_collection(@events).to_s
      end 
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    enforce_visibility(@event)
    @invite = Invite.new
    @post = Post.new({ :postable => @event })
    @posts_grid  = initialize_grid(@event.posts, :include => [:user])
    @game_events = all_visible(GameEvent).where("event_id = ?", @event.id)
    @game_servers_grid  = initialize_grid(@event.game_social_servers, :include => [:game])
    @tournaments = all_visible(Tournament).where("event_id = ?", @event.id)
    @filter = params["filter"]
    if @filter == "owned" && current_user
      @game_events = @game_events.where("game_id in (?)", current_user.games.map {|g| g.id })
    end
    @filter_tournaments = params["filter_tournaments"]
    if @filter_tournaments == "owned" && current_user
      @tournaments = @tournaments.where("game_id in (?)", current_user.games.map {|g| g.id })
    end
    
    @game_events_grid = initialize_grid(@game_events, :include => [:game])
    @tournaments_grid = initialize_grid(@tournaments, :include => [:game])
    respond_to do |format|
      format.html {}
      format.ics do
        expires_now
        render inline: Ical.ical_from_collection(@game_events).to_s
      end 
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.object_permission = ObjectPermission.new
    @event.start_time = DateTime.now
    @event.end_time = DateTime.now
  end

  # GET /events/1/edit
  def edit
    enforce_ownership(@event)
  end

  # GET /events/1/invite
  def invite
    enforce_visibility(@event)
    @invite = Invite.new
  end

  # POST /events/1/invite
  def send_invite
    enforce_visibility(@event)
    @invite = Invite.new(invite_params)
    @invite.event = @event
    @invite.user =  current_user
    @invite.deliver
    redirect_to event_path(@event), notice: "Invite sent"
  end

  # GET /events/1/join
  def join
    enforce_visibility(@event)
    user = User.find_by_id(params[:user_id]) || current_user
    enforce_ownership(user)
    user.join_event(@event)

    respond_to do |format|
      format.html { redirect_to return_url, notice: 'Event joined.' }
      format.js { render json: {} }
    end
  end

  # GET /events/1/leave
  def leave
    enforce_visibility(@event)
    user = User.find_by_id(params[:user_id]) || current_user
    enforce_ownership(user)
    user.leave_event(@event)

    respond_to do |format|
      format.html { redirect_to return_url, notice: 'Event left.' }
      format.js { render json: {} }
    end
  end

  def game_social_servers
    game_server = GameSocialServer.find(params[:game_social_server_id])
    enforce_ownership(game_server)
    enforce_visibility(@event)
    @event.game_social_servers.append(game_server) unless @event.game_social_servers.include? game_server
    redirect_to event_path(@event), notice: "Added #{game_server.name} to game servers"
  end

  def delete_game_social_server
    game_server = GameSocialServer.find(params[:game_social_server_id])
    enforce_ownership(game_server)
    enforce_visibility(@event)
    @event.game_social_servers.delete(game_server) if @event.game_social_servers.include? game_server
    redirect_to event_path(@event), notice: "Removed #{game_server.name} from game servers"
  end

  def return_url
    request.referrer || events_path
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user unless @event.user
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    enforce_ownership(@event)
    respond_to do |format|
      if @event.update(event_params)
        @event.notify
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    enforce_ownership(@event)
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, 
                                    :description, 
                                    :start_time, 
                                    :end_time, 
                                    :user_id, 
                                    :location,
                                    :image_url,
                                    object_permission_attributes: [:permission_type])
    end

    def invite_params
      params.require(:invite).permit(:email)
    end
end
