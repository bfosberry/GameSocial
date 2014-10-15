class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :join, :leave, :invite, :send_invite]
  before_filter :spoof_login, only: [:show, :index]
  before_filter :enforce_login

  # GET /events
  # GET /events.json
  def index
    @events_grid = initialize_grid(all_visible(Event), 
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
    @invite = Invite.new
    @post = Post.new({ :postable => @event })
    @posts_grid  = initialize_grid(@event.posts, :include => [:user])
    @game_events_grid = initialize_grid(GameEvent, :include => [:game])
    respond_to do |format|
      format.html {}
      format.ics do
        expires_now
        render inline: Ical.ical_from_collection(@event.game_events).to_s
      end 
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.object_permission = ObjectPermission.new
  end

  # GET /events/1/edit
  def edit
    enforce_ownership(@event)
  end

  # GET /events/1/invite
  def invite
    @invite = Invite.new
  end

  # POST /events/1/invite
  def send_invite
    @invite = Invite.new(invite_params)
    @invite.event = @event
    @invite.user =  current_user
    @invite.deliver
    redirect_to event_path(@event), notice: "Invite sent"
  end

  # GET /events/1/join
  def join
    user = User.find_by_id(params[:user_id]) || current_user
    enforce_ownership(user)
    user.join_event(@event)
    redirect_to events_path, notice: 'Event joined.' 
  end

  # GET /events/1/leave
  def leave
    user = User.find_by_id(params[:user_id]) || current_user
    ennforce_ownership(user)
    user.leave_event(@event)
    redirect_to events_path, notice: 'Event left.' 
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
                                    :start_time_date, 
                                    :start_time_time, 
                                    :end_time_date, 
                                    :end_time_time, 
                                    :user_id, 
                                    :location, 
                                    object_permission_attributes: [:permission_type])
    end

    def invite_params
      params.require(:invite).permit(:email)
    end
end
