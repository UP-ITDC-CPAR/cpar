class CreateCloseoutForms < ActiveRecord::Migration
  def change
    create_table :closeout_forms do |t|
      t.integer :auditor_id
      t.integer :issue_id
      t.integer :qmr_id
      t.boolean :completed, :boolean, default: false
      t.date :closeout_date

      t.timestamps
    end
  end
end
