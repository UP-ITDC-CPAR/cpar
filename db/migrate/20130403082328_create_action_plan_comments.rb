class CreateActionPlanComments < ActiveRecord::Migration
  def change
    create_table :action_plan_comments do |t|
      t.integer :action_plan_id
      t.text :content
      t.integer :user_id
      t.boolean :log_comment, :boolean, default: false

      t.timestamps
    end
  end
end
