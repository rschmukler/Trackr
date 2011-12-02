class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :package_id
      t.integer :count
      t.string :name

      t.timestamps
    end
  end
end
