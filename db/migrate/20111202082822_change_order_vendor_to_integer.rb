class ChangeOrderVendorToInteger < ActiveRecord::Migration
  def up
    remove_column :orders, :vendor
    add_column :orders, :vendor_id, :integer
  end

  def down
    remove_column :vendors, :vendor_id
    add_column :orders, :vendor, :string
  end
end
