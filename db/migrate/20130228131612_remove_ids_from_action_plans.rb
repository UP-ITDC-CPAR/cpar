class RemoveIdsFromActionPlans < ActiveRecord::Migration
  def up
    remove_column :action_plans, :activity_id
    remove_column :action_plans, :ap_verification_id
  end

  def down
    add_column :action_plans, :ap_verification_id, :integer
    add_column :action_plans, :activity_id, :integer
  end
end
