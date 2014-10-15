class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :join, :leave, :invite, :send_invite]

  # GET /groups
  # GET /groups.json
  def index
    @groups_grid = initialize_grid(all_visible(Group), :include => [:user])

  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @invite = Invite.new
  end

  # GET /groups/new
  def new
    @group = Group.new
    @group.object_permission = ObjectPermission.new
  end

  # GET /groups/1/edit
  def edit
  end

  # GET /groups/1/invite
  def invite
    @invite = Invite.new
  end

  # POST /groups/1/invite
  def send_invite
    @invite = Invite.new(invite_params)
    @invite.group = @group
    @invite.user =  current_user
    @invite.deliver
    redirect_to group_path(@group), notice: "Invite sent"
  end

  # GET /events/1/join
  def join
    user = User.find_by_id(params[:user_id]) || current_user
    validate_ownership(user)
    user.join_group(@group)
    redirect_to groups_path, notice: 'Group joined.' 
  end

  # GET /events/1/leave
  def leave
    user = User.find_by_id(params[:user_id]) || current_user
    validate_ownership(user)
    user.leave_event(@group)
    redirect_to groups_path, notice: 'Group left.' 
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.user = current_user unless @group.user
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    enforce_ownership(@group)
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    enforce_ownership(@group)
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, 
                                    :description, 
                                    :user_id,
                                    object_permission_attributes: [:permission_type])
    end

    def invite_params
      params.require(:invite).permit(:email)
    end
end
