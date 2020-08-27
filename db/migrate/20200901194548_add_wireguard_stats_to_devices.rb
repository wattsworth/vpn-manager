class AddWireguardStatsToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :transfer_tx, :integer
    add_column :devices, :transfer_rx, :integer
    rename_column :devices, :last_heartbeat, :latest_handshake

  end
end
