
# Create a hosts file for dnsmasq name resolution
class BuildDnsmasqConfig
  include ServiceStatus
  include ConfigDifference

  def run(devices, config_file, restart_cmd)
    # Create the Dnsmasq configuration file based off
    # the devices and settings provided
    config = ApplicationController.render(template: 'services/dnsmasq_hosts.erb',
                                          assigns: {devices: devices},
                                          options: :plain, layout: false)
    restart_required = new_configurations?(config, config_file)
    File.write(config_file, config)
    _restart_service(restart_cmd) if restart_required
    File.write(config_file, config)
  end

  def _restart_service(restart_cmd)
    system(restart_cmd)
    set_notice("Restarted dnsmasq.")
  end
end
