class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :type_id
      t.integer :department_id
      t.integer :impact_id
      t.integer :iso_nc_id
      t.integer :status_id
      t.integer :cause_id
      t.integer :action_plan_id

      t.timestamps
    end
  end
end
