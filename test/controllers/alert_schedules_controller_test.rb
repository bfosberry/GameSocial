require 'test_helper'

class AlertSchedulesControllerTest < ActionController::TestCase
  setup do
    @alert_schedule = alert_schedules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:alert_schedules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create alert_schedule" do
    assert_difference('AlertSchedule.count') do
      post :create, alert_schedule: { name: @alert_schedule.name, user_id: @alert_schedule.user_id }
    end

    assert_redirected_to alert_schedule_path(assigns(:alert_schedule))
  end

  test "should show alert_schedule" do
    get :show, id: @alert_schedule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @alert_schedule
    assert_response :success
  end

  test "should update alert_schedule" do
    patch :update, id: @alert_schedule, alert_schedule: { name: @alert_schedule.name, user_id: @alert_schedule.user_id }
    assert_redirected_to alert_schedule_path(assigns(:alert_schedule))
  end

  test "should destroy alert_schedule" do
    assert_difference('AlertSchedule.count', -1) do
      delete :destroy, id: @alert_schedule
    end

    assert_redirected_to alert_schedules_path
  end
end
