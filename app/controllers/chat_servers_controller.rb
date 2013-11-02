class ChatServersController < ApplicationController
  before_action :set_chat_server, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_login

  # GET /chat_servers
  # GET /chat_servers.json
  def index
    @chat_servers = ChatServer.all
  end

  # GET /chat_servers/1
  # GET /chat_servers/1.json
  def show
  end

  # GET /chat_servers/new
  def new
    @chat_server = ChatServer.new
  end

  # GET /chat_servers/1/edit
  def edit
    enforce_ownership(@chat_server)
  end

  # POST /chat_servers
  # POST /chat_servers.json
  def create
    @chat_server = ChatServer.new(chat_server_params)
    @chat_server.user = current_user unless @chat_server.user
    respond_to do |format|
      if @chat_server.save
        format.html { redirect_to @chat_server, notice: 'Chat server was successfully created.' }
        format.json { render action: 'show', status: :created, location: @chat_server }
      else
        format.html { render action: 'new' }
        format.json { render json: @chat_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_servers/1
  # PATCH/PUT /chat_servers/1.json
  def update
    enforce_ownership(@chat_server)
    respond_to do |format|
      if @chat_server.update(chat_server_params)
        format.html { redirect_to @chat_server, notice: 'Chat server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @chat_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_servers/1
  # DELETE /chat_servers/1.json
  def destroy
    enforce_ownership(@chat_server)
    @chat_server.destroy
    respond_to do |format|
      format.html { redirect_to chat_servers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_server
      @chat_server = ChatServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chat_server_params
      params.require(:chat_server).permit(:server_type, :user_id, :ip, :port, :public, :name, :password, :room, :room_password)
    end
end
