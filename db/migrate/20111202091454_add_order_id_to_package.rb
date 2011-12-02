class AddOrderIdToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :order_id, :integer
  end
end
