
class BuildConfigs
  include ServiceStatus

  def run(groups, devices)

    wg_config = Rails.configuration.x.wireguard
    wg_service = BuildWireguardConfig.new
    wg_service.run(devices.where(enabled: true),
                   wg_config.public_key, wg_config.private_key,
                   wg_config.ip_address, wg_config.port,
                   wg_config.config_file, wg_config.restart_cmd)
    absorb_status(wg_service)

    dnsmasq_config = Rails.configuration.x.dnsmasq
    dns_service = BuildDnsmasqConfig.new
    dns_service.run(devices,
                    dnsmasq_config.config_file,
                    dnsmasq_config.restart_cmd)
    absorb_status(dns_service)

    nagios_config = Rails.configuration.x.nagios
    nagios_service = BuildNagiosConfig.new
    nagios_service.run(groups, devices,
                       nagios_config.host_profile,
                       nagios_config.config_file,
                       nagios_config.restart_cmd)
    absorb_status(nagios_service)
    set_notice("Rebuilt configuration files.") if notices.empty?
    self
  end
end