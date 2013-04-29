class CreateIssueImpacts < ActiveRecord::Migration
  def change
    create_table :issue_impacts do |t|
      t.string :name

      t.timestamps
    end
  end
end
