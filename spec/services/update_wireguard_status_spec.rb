require 'rails_helper'

describe 'UpdateWireguardStatus service' do
  let(:public_key){ '8mTYgScwyaLqKqHM4mxWvKHsdeqQbmcAKfiJLAa13EI=' }
  let(:private_key){ 'aGaQX0U+FQgNBIiYfRr+s/SDFH43dm2fp1PzWe0tjV4=' }
  let(:ip_address) { '192.168.1.1'}
  let(:port){ 51280 }
  let(:devices){ [Device.new(hostname: 'device1',
                             vpn_ip_address: '192.168.1.2',
                             public_key: 'eFwAawUhmGhQZbYYxnh6qpNoC9u8ITxVSckqGcL+B2E='),
                  Device.new(hostname: 'device2',
                             vpn_ip_address: '192.168.1.3',
                             public_key: 'fBCNTesi4DJ0nA4/gxI6jgDk6PNTeYeY8MabRAh4FBk=')]}
  it 'updates devices based on wireguard and ipstack info', :vcr do
    service = UpdateWireguardStatus.new
    status = File.read(File.dirname(__FILE__)+'/reference_wireguard_status.txt')
    expect(service).to receive(:_get_status).and_return(status)
    service.run(devices,'', "test_api_key")

    # wireguard info
    expect(devices[0].host_ip_address).to eq('118.31.19.9')
    expect(devices[0].transfer_rx).to eq(2790615576)
    expect(devices[0].transfer_tx).to eq(124713880)
    expected_dt = Time.at(1598896991).to_datetime
    expect(devices[0].latest_handshake).to eq(expected_dt)
    # ipstack api info
    expect(devices[0].latitude).to be_within(0.01).of(30.23)
    expect(devices[0].longitude).to be_within(0.01).of(120.15)
    expect(devices[0].location_flag).to eq('https://assets.ipstack.com/flags/cn.svg')
    expect(devices[0].location).to eq('Hangzhou, Zhejiang, China')

    # wireguard info
    expect(devices[1].host_ip_address).to eq('98.43.123.19')
    expect(devices[1].transfer_rx).to eq(19399056)
    expect(devices[1].transfer_tx).to eq(5249520)
    expected_dt = Time.at(1598896883).to_datetime
    expect(devices[1].latest_handshake).to eq(expected_dt)
    # ipstack api info
    expect(devices[1].latitude).to be_within(0.01).of(40.76)
    expect(devices[1].longitude).to be_within(0.01).of(-73.98)
    expect(devices[1].location_flag).to eq('https://assets.ipstack.com/flags/us.svg')
    expect(devices[1].location).to eq('Manhattan, New York, United States')

  end
end