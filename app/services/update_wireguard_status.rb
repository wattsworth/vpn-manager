require 'open3'

# Create a wireguard configuration file for the VPN server
class UpdateWireguardStatus
  include ServiceStatus
  def run(devices, status_cmd, ipstack_api_key)
    # status fields:
    #   public-key, preshared-key, endpoint,
    #   allowed-ips, latest-handshake, transfer-rx, transfer-tx,
    #   persistent-keepalive.
    #
    status = _get_status(status_cmd).split("\n")
    # the first line is the local interface and is ignored
    status = status.drop(1)
    status.each do |status_line|
      items = status_line.split("\t")
      public_key = items[0]
      if items[2]=='(none)'
        host_ip_address = ''
      else
        host_ip_address = items[2].split(':')[0]
      end
      latest_handshake = Time.at(items[4].to_i).to_datetime
      transfer_rx = items[5]
      transfer_tx = items[6]
      device = devices.select { |d| d.public_key == public_key}
      if device.empty?
        Rails.logger.warn("Unknown VPN device [#{status_line}]")
        next
      end
      device = device.first #only one element will match
      if (host_ip_address != device.host_ip_address) and (host_ip_address != "")
        ip_data = _get_ip_info(host_ip_address, ipstack_api_key)
        device.latitude = ip_data['latitude']
        device.longitude = ip_data['longitude']
        device.location_flag = ip_data['location']['country_flag'].gsub("http","https")
        device.location = "#{ip_data['city']}, #{ip_data['region_name']}, #{ip_data['country_name']}"
        device.host_ip_address = host_ip_address
      end
      device.latest_handshake = latest_handshake
      device.transfer_rx = transfer_rx
      device.transfer_tx = transfer_tx
    end
  end
  def _get_status(status_cmd)
    Rails.logger.warn("Retrieving wireguard status")
    stdout, stderr, status = Open3.capture3(status_cmd)
    stdout
  end

  def _get_ip_info(ip_address, api_key)
    response = HTTParty.get("http://api.ipstack.com/#{ip_address}?access_key=#{api_key}")
    JSON.parse response.body
  end
end