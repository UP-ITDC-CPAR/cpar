class CreateCauseComments < ActiveRecord::Migration
  def change
    create_table :cause_comments do |t|
      t.integer :cause_id
      t.text :content
      t.integer :user_id
      t.boolean :log_comment, :boolean, default: false

      t.timestamps
    end
  end
end
