class ModifyDeviceAttributes < ActiveRecord::Migration[6.0]
  def change
    rename_column :devices, :location, :location_flag
  end
end
