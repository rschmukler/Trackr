class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.date :ship_date
      t.integer :user_id
      t.integer :vendor_id
      t.integer :carrier_id
      t.string :name

      t.timestamps
    end
  end
end
