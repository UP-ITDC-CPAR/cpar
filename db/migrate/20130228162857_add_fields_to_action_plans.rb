class AddFieldsToActionPlans < ActiveRecord::Migration
  def change
    add_column :action_plans, :ap_reviewer_id, :integer
    add_column :action_plans, :final_review_date, :date
    add_column :action_plans, :implementation_reviewer_id, :integer
    add_column :action_plans, :final_implementation_review_date, :date
  end
end
