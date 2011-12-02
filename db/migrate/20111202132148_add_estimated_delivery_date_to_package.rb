class AddEstimatedDeliveryDateToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :estimated_delivery_date, :date
  end
end
