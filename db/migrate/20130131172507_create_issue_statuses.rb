class CreateIssueStatuses < ActiveRecord::Migration
  def change
    create_table :issue_statuses do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
