class AddLastTrackedAtToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :last_tracked_at, :datetime
  end
end
