class CreateIsoNcs < ActiveRecord::Migration
  def change
    create_table :iso_ncs do |t|
      t.string :title

      t.timestamps
    end
  end
end
