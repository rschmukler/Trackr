class CreateEmailAddresses < ActiveRecord::Migration
  def change
    create_table :email_addresses do |t|
      t.string :address
      t.integer :user_id
      t.boolean :confirmed
      t.string :token

      t.timestamps
    end
  end
end
