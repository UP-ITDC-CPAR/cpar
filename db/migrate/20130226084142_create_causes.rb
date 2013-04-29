class CreateCauses < ActiveRecord::Migration
  def change
    create_table :causes do |t|
      t.text :description
      t.date :date_issued
      t.date :closeout_date
      t.integer :user_id

      t.timestamps
    end
  end
end
