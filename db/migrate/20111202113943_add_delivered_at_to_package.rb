class AddDeliveredAtToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :delivered_at, :date
  end
end
