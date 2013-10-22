class AlertSchedulesController < ApplicationController
  before_action :set_alert_schedule, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_login

  # GET /alert_schedules
  # GET /alert_schedules.json
  def index
    @alert_schedules = all_owned(AlertSchedule)
  end

  # GET /alert_schedules/1
  # GET /alert_schedules/1.json
  def show
  end

  # GET /alert_schedules/new
  def new
    @alert_schedule = AlertSchedule.new
  end

  # GET /alert_schedules/1/edit
  def edit
  end

  # POST /alert_schedules
  # POST /alert_schedules.json
  def create
    @alert_schedule = AlertSchedule.new(alert_schedule_params)

    respond_to do |format|
      if @alert_schedule.save
        format.html { redirect_to edit_alert_schedule_path(@alert_schedule), notice: 'Alert schedule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @alert_schedule }
      else
        format.html { render action: 'new' }
        format.json { render json: @alert_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alert_schedules/1
  # PATCH/PUT /alert_schedules/1.json
  def update
    respond_to do |format|
      if @alert_schedule.update(alert_schedule_params)
        format.html { redirect_to @alert_schedule, notice: 'Alert schedule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @alert_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alert_schedules/1
  # DELETE /alert_schedules/1.json
  def destroy
    @alert_schedule.destroy
    respond_to do |format|
      format.html { redirect_to alert_schedules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert_schedule
      @alert_schedule = AlertSchedule.find(params[:id])
      enforce_ownership(@alert_schedule)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alert_schedule_params
      params.require(:alert_schedule).permit(:user_id, :name, :alert_conditions_attributes => [
        :id, 
        :value => ['start_time', 'end_time', :games => [], :users => [], :days => []]])
    end
end
