class AddStatusIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :status_id, :integer
  end
end
