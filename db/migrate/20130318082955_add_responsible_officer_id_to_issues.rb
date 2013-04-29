class AddResponsibleOfficerIdToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :responsible_officer_id, :integer
  end
end
