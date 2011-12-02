class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :from_text
      t.text :body_text
      t.string :subject_text

      t.timestamps
    end
  end
end
