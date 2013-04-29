class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.date :target_date
      t.date :actual_date
      t.text :result

      t.timestamps
    end
  end
end
