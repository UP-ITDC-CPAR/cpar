class CreateActionPlanStatuses < ActiveRecord::Migration
  def change
    create_table :action_plan_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
