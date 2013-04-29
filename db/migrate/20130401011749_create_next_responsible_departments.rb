class CreateNextResponsibleDepartments < ActiveRecord::Migration
  def change
    create_table :next_responsible_departments do |t|
      t.integer :issue_id
      t.integer :department_id
      t.integer :responsible_officer_id
      t.integer :dept_status_id
      t.integer :responsibility_level

      t.timestamps
    end
  end
end
