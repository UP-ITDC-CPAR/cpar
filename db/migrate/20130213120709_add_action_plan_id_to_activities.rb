class AddActionPlanIdToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :action_plan_id, :integer
    #add_index  :activities, :action_plan_id
  end
end
