class CreateActionPlans < ActiveRecord::Migration
  def change
    create_table :action_plans do |t|
      t.text :description
      t.integer :activity_id
      t.integer :ap_verification_id

      t.timestamps
    end
  end
end
