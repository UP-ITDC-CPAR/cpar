class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :type_id
      t.string :phone
      t.string :mobile
      t.string :email
      t.integer :department_id

      t.timestamps
    end
  end
end
