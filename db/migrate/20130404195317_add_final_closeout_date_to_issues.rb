class AddFinalCloseoutDateToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :final_closeout_date, :date
  end
end
