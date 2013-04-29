class CreateActivityStatuses < ActiveRecord::Migration
  def change
    create_table :activity_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
