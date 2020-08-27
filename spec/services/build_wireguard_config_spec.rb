require 'rails_helper'

describe 'BuildWireguardConfig service' do
  let(:public_key){ 'test_public_key' }
  let(:private_key){ 'test_private_key' }
  let(:ip_address) { '192.168.1.1'}
  let(:port){ 51280 }
  let(:devices){ [Device.new(hostname: 'device1',
                             vpn_ip_address: '192.168.1.2',
                             public_key: 'eFwAawUhmGhQZbYYxnh6qpNoC9u8ITxVSckqGcL+B2E='),
                  Device.new(hostname: 'device2',
                             vpn_ip_address: '192.168.1.3',
                             public_key: 'fBCNTesi4DJ0nA4/gxI6jgDk6PNTeYeY8MabRAh4FBk=')]}
  it 'creates the new configuration file' do
    config_file = Tempfile.new('wg0.conf')
    service = BuildWireguardConfig.new
    expect(service).to receive(:_restart_wireguard)
    service.run(devices, public_key, private_key,
                ip_address, port, config_file.path,'' )
    result = config_file.open.read
    config_file.unlink
    reference = File.read(File.dirname(__FILE__)+'/reference_wireguard_config.conf')
    expect(result).to eq reference
  end
  it 'restarts wireguard on significant config changes' do
    devices[0].vpn_ip_address = '192.168.1.9'
    reference = File.read(File.dirname(__FILE__)+'/reference_wireguard_config.conf')
    config_file = Tempfile.new('wg0.conf')
    File.write(config_file, reference)
    service = BuildWireguardConfig.new
    expect(service).to receive(:_restart_wireguard)
    service.run(devices, public_key, private_key,
                ip_address, port, config_file.path,'' )

  end
  it 'does not restart wireguard on insignificant changes' do
    devices[0].hostname = 'newname'
    reference = File.read(File.dirname(__FILE__)+'/reference_wireguard_config.conf')
    config_file = Tempfile.new('wg0.conf')
    File.write(config_file, reference)
    service = BuildWireguardConfig.new
    expect(service).to_not receive(:_restart_wireguard)
    service.run(devices, public_key, private_key,
                ip_address, port, config_file.path,'' )

  end
end