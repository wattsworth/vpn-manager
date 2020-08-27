require 'rails_helper'

describe 'BuildDnsmasqConfig service' do
  let(:devices){ [Device.new(hostname: 'device1.vpn.test.net',
                             vpn_ip_address: '192.168.1.2',
                             public_key: 'eFwAawUhmGhQZbYYxnh6qpNoC9u8ITxVSckqGcL+B2E='),
                  Device.new(hostname: 'device2.vpn.test.net',
                             vpn_ip_address: '192.168.1.3',
                             public_key: 'fBCNTesi4DJ0nA4/gxI6jgDk6PNTeYeY8MabRAh4FBk=')]}
  it 'creates the new configuration file' do
    config_file = Tempfile.new('dnsmasq.hosts')
    service = BuildDnsmasqConfig.new
    service.run(devices, config_file.path, '')
    result = config_file.open.read
    config_file.unlink
    reference = File.read(File.dirname(__FILE__)+'/reference_dnsmasq_hosts.conf')
    expect(result).to eq reference
  end
  it 'restarts dnsmasq on significant config changes' do
    devices[0].hostname = 'new.vpn.test.net'
    reference = File.read(File.dirname(__FILE__)+'/reference_dnsmasq_hosts.conf')
    config_file = Tempfile.new('dnsmasq.hosts')
    File.write(config_file, reference)
    service = BuildDnsmasqConfig.new
    expect(service).to receive(:_restart_service)
    service.run(devices, config_file.path,'' )
  end
  it 'does not restart dnsmasq on insignificant changes' do
    # dnsmasq configurations do not use host_ip_addressses
    devices[0].host_ip_address = '1.1.1.1'
    reference = File.read(File.dirname(__FILE__)+'/reference_dnsmasq_hosts.conf')
    config_file = Tempfile.new('dnsmasq.hosts')
    File.write(config_file, reference)
    service = BuildDnsmasqConfig.new
    expect(service).to_not receive(:_restart_service)
    service.run(devices, config_file.path,'' )
  end
end