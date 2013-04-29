class CreateCauseAttachments < ActiveRecord::Migration
  def change
    create_table :cause_attachments do |t|
      t.string :description
      t.integer :cause_id
      t.string :myfile
      t.integer :user_id

      t.timestamps
    end
  end
end
