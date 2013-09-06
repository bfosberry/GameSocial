require 'test_helper'

class ChatServersControllerTest < ActionController::TestCase
  setup do
    @chat_server = chat_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chat_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chat_server" do
    assert_difference('ChatServer.count') do
      post :create, chat_server: { ip: @chat_server.ip, name: @chat_server.name, password: @chat_server.password, port: @chat_server.port, public: @chat_server.public, room: @chat_server.room, room_password: @chat_server.room_password, type: @chat_server.type, user_id: @chat_server.user_id }
    end

    assert_redirected_to chat_server_path(assigns(:chat_server))
  end

  test "should show chat_server" do
    get :show, id: @chat_server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @chat_server
    assert_response :success
  end

  test "should update chat_server" do
    patch :update, id: @chat_server, chat_server: { ip: @chat_server.ip, name: @chat_server.name, password: @chat_server.password, port: @chat_server.port, public: @chat_server.public, room: @chat_server.room, room_password: @chat_server.room_password, type: @chat_server.type, user_id: @chat_server.user_id }
    assert_redirected_to chat_server_path(assigns(:chat_server))
  end

  test "should destroy chat_server" do
    assert_difference('ChatServer.count', -1) do
      delete :destroy, id: @chat_server
    end

    assert_redirected_to chat_servers_path
  end
end
