class AddIssueIdToCauses < ActiveRecord::Migration
  def change
    add_column :causes, :issue_id, :integer
  end
end
