class CreateIssueAttachments < ActiveRecord::Migration
  def change
    create_table :issue_attachments do |t|
      t.string :myfile
      t.string :description
      t.integer :user_id
      t.integer :issue_id

      t.timestamps
    end
  end
end
