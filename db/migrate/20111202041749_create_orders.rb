class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.date :order_date
      t.string :order_number
      t.integer :user_id
      t.string :vendor

      t.timestamps
    end
  end
end
