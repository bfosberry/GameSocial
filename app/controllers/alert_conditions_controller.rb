class AlertConditionsController < ApplicationController
  before_action :set_alert_condition, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_login

  # GET /alert_conditions
  # GET /alert_conditions.json
  def index
    @alert_conditions = AlertCondition.all
  end

  # GET /alert_conditions/1
  # GET /alert_conditions/1.json
  def show
  end

  # GET /alert_conditions/new
  def new
    @alert_condition = AlertCondition.new
  end

  # GET /alert_conditions/1/edit
  def edit
  end

  # POST /alert_conditions
  # POST /alert_conditions.json
  def create
    @alert_condition = AlertCondition.new(alert_condition_params)

    respond_to do |format|
      if @alert_condition.save
        format.html { redirect_to @alert_condition, notice: 'Alert condition was successfully created.' }
        format.json { render action: 'show', status: :created, location: @alert_condition }
      else
        format.html { render action: 'new' }
        format.json { render json: @alert_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alert_conditions/1
  # PATCH/PUT /alert_conditions/1.json
  def update
    respond_to do |format|
      if @alert_condition.update(alert_condition_params)
        format.html { redirect_to @alert_condition, notice: 'Alert condition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @alert_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alert_conditions/1
  # DELETE /alert_conditions/1.json
  def destroy
    @alert_condition.destroy
    respond_to do |format|
      format.html { redirect_to alert_conditions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert_condition
      @alert_condition = AlertCondition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alert_condition_params
      params.require(:alert_condition).permit(:condition_type, :value)
    end
end
