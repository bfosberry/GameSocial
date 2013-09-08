require 'test_helper'

class AlertConditionsControllerTest < ActionController::TestCase
  setup do
    @alert_condition = alert_conditions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:alert_conditions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create alert_condition" do
    assert_difference('AlertCondition.count') do
      post :create, alert_condition: { condition_type: @alert_condition.condition_type, value: @alert_condition.value }
    end

    assert_redirected_to alert_condition_path(assigns(:alert_condition))
  end

  test "should show alert_condition" do
    get :show, id: @alert_condition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @alert_condition
    assert_response :success
  end

  test "should update alert_condition" do
    patch :update, id: @alert_condition, alert_condition: { condition_type: @alert_condition.condition_type, value: @alert_condition.value }
    assert_redirected_to alert_condition_path(assigns(:alert_condition))
  end

  test "should destroy alert_condition" do
    assert_difference('AlertCondition.count', -1) do
      delete :destroy, id: @alert_condition
    end

    assert_redirected_to alert_conditions_path
  end
end
