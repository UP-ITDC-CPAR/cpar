class CreateIssueComments < ActiveRecord::Migration
  def change
    create_table :issue_comments do |t|
      t.integer :issue_id
      t.text :content
      t.integer :user_id
      t.boolean :log_comment, :boolean, default: false

      t.timestamps
    end
  end
end
