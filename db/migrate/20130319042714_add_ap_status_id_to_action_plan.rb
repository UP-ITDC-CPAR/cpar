class AddApStatusIdToActionPlan < ActiveRecord::Migration
  def change
    add_column :action_plans, :ap_status_id, :integer
  end
end
