desc "Update device information based on wireguard status"
namespace :devices do
  task update: "environment" do
    devices = Device.where(enabled: true)
    wg_service = UpdateWireguardStatus.new
    wg_service.run(devices,
                   Rails.configuration.x.wireguard.status_cmd,
                   Rails.configuration.ipstack_api_key)
    if wg_service.errors?
      puts "ERROR: "+wg_service.errors.join(', ')
    else
      devices.each{|device| device.save}
      puts "Devices updated"
    end
  end
end