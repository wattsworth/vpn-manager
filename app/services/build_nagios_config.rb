
# Create a hosts file for dnsmasq name resolution
class BuildNagiosConfig
  include ServiceStatus
  include ConfigDifference

  def run(groups, devices, host_profile, config_file, restart_cmd)
    # Create the Dnsmasq configuration file based off
    # the devices and settings provided
    config = ApplicationController.render(template: 'services/nagios_hosts.erb',
                                          assigns: {devices: devices, groups: groups,
                                                    host_profile: host_profile},
                                          options: :plain, layout: false)
    config.delete_suffix!("\n")
    restart_required = new_configurations?(config, config_file)
    File.write(config_file, config)
    _restart_service(restart_cmd) if restart_required
    File.write(config_file, config)
  end

  def _restart_service(restart_cmd)
    set_notice("Restarted nagios.")
    system(restart_cmd)
  end
end
