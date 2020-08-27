class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.datetime :last_heartbeat
      t.string   :vpn_ip_address
      t.string   :host_ip_address
      t.float    :latitude
      t.float    :longitude
      t.string   :location
      t.string   :hostname
      t.string   :public_key
      t.string   :token
      t.belongs_to :user
      t.datetime :enrolled_on
      t.boolean :enabled
      t.timestamps
    end
  end
end
