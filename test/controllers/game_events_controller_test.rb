require 'test_helper'

class GameEventsControllerTest < ActionController::TestCase
  setup do
    @game_event = game_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_event" do
    assert_difference('GameEvent.count') do
      post :create, game_event: { chat_server_id: @game_event.chat_server_id, description: @game_event.description, end_time: @game_event.end_time, event_id: @game_event.event_id, game_id: @game_event.game_id, game_social_server_id: @game_event.game_social_server_id, start_time: @game_event.start_time, title: @game_event.title, user_id: @game_event.user_id }
    end

    assert_redirected_to game_event_path(assigns(:game_event))
  end

  test "should show game_event" do
    get :show, id: @game_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_event
    assert_response :success
  end

  test "should update game_event" do
    patch :update, id: @game_event, game_event: { chat_server_id: @game_event.chat_server_id, description: @game_event.description, end_time: @game_event.end_time, event_id: @game_event.event_id, game_id: @game_event.game_id, game_social_server_id: @game_event.game_social_server_id, start_time: @game_event.start_time, title: @game_event.title, user_id: @game_event.user_id }
    assert_redirected_to game_event_path(assigns(:game_event))
  end

  test "should destroy game_event" do
    assert_difference('GameEvent.count', -1) do
      delete :destroy, id: @game_event
    end

    assert_redirected_to game_events_path
  end
end
