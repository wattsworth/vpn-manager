require 'rails_helper'

describe 'BuildNagiosConfig service' do
  let(:devices){ [Device.new(hostname: 'device1.vpn.test.net',
                             vpn_ip_address: '192.168.1.2',
                             public_key: 'eFwAawUhmGhQZbYYxnh6qpNoC9u8ITxVSckqGcL+B2E='),
                  Device.new(hostname: 'device2.vpn.test.net',
                             vpn_ip_address: '192.168.1.3',
                             public_key: 'fBCNTesi4DJ0nA4/gxI6jgDk6PNTeYeY8MabRAh4FBk=')]}
  let(:groups){ [Group.new(name: 'grp1', description: 'group1'),
                 Group.new(name: 'grp2', description: 'group2')]}
  it 'creates the new configuration file' do
    groups[0].devices << devices[0]
    groups[1].devices << devices[0]
    groups[1].devices << devices[1]

    config_file = Tempfile.new('nagios_hosts.cfg')
    service = BuildNagiosConfig.new
    service.run(groups, devices, 'def-host',
                config_file.path, '')
    result = config_file.open.read
    config_file.unlink
    reference = File.read(File.dirname(__FILE__)+'/reference_nagios_hosts.conf')
    expect(result).to eq reference
  end
  it 'restarts nagios on significant config changes' do
    groups[0].devices << devices[0]
    groups[1].devices << devices[0] # remove device[1] from group
    reference = File.read(File.dirname(__FILE__)+'/reference_nagios_hosts.conf')
    config_file = Tempfile.new('nagios_hosts.cfg')
    File.write(config_file, reference)
    service = BuildNagiosConfig.new
    expect(service).to receive(:_restart_service)
    service.run(groups, devices, 'def-host',
                config_file.path,'' )
    end
  it 'does not restart nagios on insignificant changes' do
    groups[0].devices << devices[0]
    groups[1].devices << devices[0]
    groups[1].devices << devices[1]
    # nagios configurations do not use IP addresses
    devices[0].vpn_ip_address = '1.1.1.1'
    reference = File.read(File.dirname(__FILE__)+'/reference_nagios_hosts.conf')
    config_file = Tempfile.new('nagios_hosts.cfg')
    File.write(config_file, reference)
    service = BuildNagiosConfig.new
    expect(service).to_not receive(:_restart_service)
    service.run(groups, devices, 'def-host',
                config_file.path,'' )
  end
end