
# Create a wireguard configuration file for the VPN server
class BuildWireguardConfig
  include ServiceStatus
  include ConfigDifference
  def run(devices, public_key, private_key, ip_address, port, config_file, restart_cmd)
    # Create the wireguard configuration file based off
    # the devices and settings provided
    config = ApplicationController.render(template: 'services/wireguard_config.erb',
                                 assigns: {
                                     public_key: public_key,
                                     private_key: private_key,
                                     server_ip_address: ip_address,
                                     server_port: port,
                                     devices: devices},
                                          options: :plain, layout: false)
    config.delete_suffix!("\n")
    restart_required = new_configurations?(config, config_file)
    File.write(config_file, config)
    _restart_wireguard(restart_cmd) if restart_required
    self
  end

  def _restart_wireguard(restart_cmd)
    set_notice("Restarted wireguard.")
    system(restart_cmd)
  end
end