class DevicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_device, only: [:edit, :show, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # GET /devices/1
  def show

  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)
    @device.user = current_user
    unless @device.save
      render :new and return
    end
    msg = ["Created device.", rebuild_configs].join(" ")
    redirect_to devices_url, notice: msg
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    unless @device.update(device_params)
      render :edit and return
    end
    msg = ["Updated device.", rebuild_configs].join(" ")
    redirect_to devices_url, notice: msg
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    msg = ["Destroyed device.", rebuild_configs].join(" ")
    redirect_to devices_url, notice: msg
  end

  # POST /devices/rebuild
  # rebuild VPN configuration files
  def rebuild
    msg = rebuild_configs
    redirect_to devices_url, notice: msg
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def device_params
    params.require(:device).permit(:vpn_ip_address, :hostname, :public_key, :enabled)
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
