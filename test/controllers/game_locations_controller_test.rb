require 'test_helper'

class GameLocationsControllerTest < ActionController::TestCase
  setup do
    @game_location = game_locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_location" do
    assert_difference('GameLocation.count') do
      post :create, game_location: { chat_server_id: @game_location.chat_server_id, game_id: @game_location.game_id, game_server_id: @game_location.game_server_id, user_id: @game_location.user_id }
    end

    assert_redirected_to game_location_path(assigns(:game_location))
  end

  test "should show game_location" do
    get :show, id: @game_location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_location
    assert_response :success
  end

  test "should update game_location" do
    patch :update, id: @game_location, game_location: { chat_server_id: @game_location.chat_server_id, game_id: @game_location.game_id, game_server_id: @game_location.game_server_id, user_id: @game_location.user_id }
    assert_redirected_to game_location_path(assigns(:game_location))
  end

  test "should destroy game_location" do
    assert_difference('GameLocation.count', -1) do
      delete :destroy, id: @game_location
    end

    assert_redirected_to game_locations_path
  end
end
