
#IMPORTANT: Change these settings to match your configuration.

# settings for the wireguard VPN interface
Rails.application.config.x.wireguard.config_file = 'tmp/wg0.conf'
Rails.application.config.x.wireguard.ip_address = '192.168.1.1'
Rails.application.config.x.wireguard.port = 51280

# generate a key with $> wg genkey
Rails.application.config.x.wireguard.private_key = 'test_private_key'

# get the matching public key with $> wg pubkey < private.key
Rails.application.config.x.wireguard.public_key = 'test_public_key'

# In production this value should be /usr/bin/systemctl restart wg-quick@wg0
# To disable service restart set this field to an empty string
Rails.application.config.x.wireguard.restart_cmd = ''

# In production this value should be /usr/bin/wg show wg0 dump
# For testing you can replace it with cat wg0_dump.txt or similar
Rails.application.config.x.wireguard.status_cmd = "cat #{File.dirname(__FILE__)}/../../reference_wireguard_status.txt"

# Hosts file for dnsmasq, add this as an addn-hosts entry in /etc/dnsmasq.conf
# Also you should configure your VPN subdomain for local resolution
Rails.application.config.x.dnsmasq.config_file = 'tmp/dnsmasq.vpn_manager.hosts'

# In production this value should be /usr/bin/systemctl restart dnsmasq
# To disable service restart set this field to an empty string
Rails.application.config.x.dnsmasq.restart_cmd = ''

# Hosts and Hostgroups file for Nagios (/usr/local/nagios/etc/objects/vpn_manager.cfg)
# Include with a cfg_file directive in /usr/local/nagios/etc/nagios.cfg
Rails.application.config.x.nagios.config_file = 'tmp/nagios.vpn_manager.cfg'

# Nagios profile for devices, this must be defined in your Nagios configuration
Rails.application.config.x.nagios.host_profile = 'linux-server'

# In production this value should be /usr/bin/systemctl restart nagios
# To disable service restart set this field to an empty string
Rails.application.config.x.nagios.restart_cmd = ''

# Register for free API key at https://ipstack.com/ (used for device location)
Rails.application.config.ipstack_api_key = 'REPLACE_WITH_VALID_KEY'
