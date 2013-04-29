class CreateCloseoutFormDepts < ActiveRecord::Migration
  def change
    create_table :closeout_form_depts do |t|
      t.integer :dept_id
      t.integer :dept_head_id
      t.integer :officer_id

      t.timestamps
    end
  end
end
