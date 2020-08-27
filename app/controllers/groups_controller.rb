class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:edit, :show, :update, :destroy, :add, :remove]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # GET /groups/1
  def show
    member_device_ids = @group.devices.map(&:id)
    @addable_devices = Device.where.not(id: member_device_ids)
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    unless @group.save
      render :new and return
    end
    msg = ["Created group.", rebuild_configs].join(" ")
    redirect_to groups_url, notice: msg
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    unless @group.update(group_params)
      render :edit and return
    end
    msg = ["Updated group.", rebuild_configs].join(" ")
    redirect_to groups_url, notice: msg
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    msg = ["Destroyed group.", rebuild_configs].join(" ")
    redirect_to groups_url, notice: msg
  end

  # POST /groups/1/add
  def add
    device = Device.find(params[:device])
    @group.devices << (device)
    msg = ["Added device to group.", rebuild_configs].join(" ")
    redirect_to @group, notice: msg
  end

  # DELETE /groups/1/delete
  def remove
    device = Device.find(params[:device])
    @group.devices.delete(device)
    msg = ["Removed device from group.", rebuild_configs].join(" ")
    redirect_to @group, notice: msg
  end

  # POST /groups/rebuild
  # rebuild VPN configuration files
  def rebuild
    msg = rebuild_configs
    redirect_to groups_url, notice: msg
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name, :description)
  end

  def rebuild_configs
    service = BuildConfigs.new
    service.run(Group.all, Device.all)
    if service.success?
      service.notices.join(" ")
    else
      "Error: #{service.errors.join(', ')}"
    end
  end
end
