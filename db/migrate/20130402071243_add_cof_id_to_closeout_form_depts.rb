class AddCofIdToCloseoutFormDepts < ActiveRecord::Migration
  def change
    add_column :closeout_form_depts, :closeout_form_id, :integer
  end
end
