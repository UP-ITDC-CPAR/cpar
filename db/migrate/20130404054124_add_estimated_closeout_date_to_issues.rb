class AddEstimatedCloseoutDateToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :estimated_closeout_date, :date
  end
end
