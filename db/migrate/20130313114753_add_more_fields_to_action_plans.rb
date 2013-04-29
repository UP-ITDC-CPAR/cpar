class AddMoreFieldsToActionPlans < ActiveRecord::Migration
  def change
    add_column :action_plans, :issue_id, :integer
    add_column :action_plans, :responsible_officer_id, :integer
    add_column :action_plans, :approved, :boolean, default: false
    add_column :action_plans, :implemented, :boolean, default: false
  end
end
