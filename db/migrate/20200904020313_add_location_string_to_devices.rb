class AddLocationStringToDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :location, :string
  end
end
