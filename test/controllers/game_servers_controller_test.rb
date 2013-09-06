require 'test_helper'

class GameServersControllerTest < ActionController::TestCase
  setup do
    @game_server = game_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_server" do
    assert_difference('GameServer.count') do
      post :create, game_server: { current_map: @game_server.current_map, current_players: @game_server.current_players, game_id: @game_server.game_id, ip: @game_server.ip, latency: @game_server.latency, match_type: @game_server.match_type, max_players: @game_server.max_players, name: @game_server.name, port: @game_server.port, region: @game_server.region }
    end

    assert_redirected_to game_server_path(assigns(:game_server))
  end

  test "should show game_server" do
    get :show, id: @game_server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_server
    assert_response :success
  end

  test "should update game_server" do
    patch :update, id: @game_server, game_server: { current_map: @game_server.current_map, current_players: @game_server.current_players, game_id: @game_server.game_id, ip: @game_server.ip, latency: @game_server.latency, match_type: @game_server.match_type, max_players: @game_server.max_players, name: @game_server.name, port: @game_server.port, region: @game_server.region }
    assert_redirected_to game_server_path(assigns(:game_server))
  end

  test "should destroy game_server" do
    assert_difference('GameServer.count', -1) do
      delete :destroy, id: @game_server
    end

    assert_redirected_to game_servers_path
  end
end
