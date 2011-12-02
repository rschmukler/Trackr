class AddTrackingNumberToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :tracking_number, :string
  end
end
