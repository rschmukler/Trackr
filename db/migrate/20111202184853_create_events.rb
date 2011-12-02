class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :package_id
      t.datetime :date_time
      t.string :status
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
