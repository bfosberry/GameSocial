require 'ical'
class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_filter :spoof_login, only: [:show, :index]
  before_filter :enforce_login

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    respond_to do |format|
      format.html {}
      format.ics { render inline: Ical.ical_from_collection(@events).to_s}
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    respond_to do |format|
      format.html {}
      format.ics { render inline: Ical.ical_from_collection(@event.game_events).to_s}
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    enforce_ownership(@event)
  end

  # GET /events/1/join
  def join
    user = User.find_by_id(params[:user_id]) || current_user
    validate_ownership(user)
    user.join_event(@event)
    redirect_to events_path, notice: 'Event joined.' 
  end

  # GET /events/1/leave
  def leave
    user = User.find_by_id(params[:user_id]) || current_user
    validate_ownership(user)
    user.leave_event(@event)
    redirect_to events_path, notice: 'Event left.' 
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

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
      params.require(:event).permit(:name, :description, :start_time, :end_time, :user_id, :location)
    end
end
