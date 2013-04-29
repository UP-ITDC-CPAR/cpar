class RemoveCloseoutDateFromCauses < ActiveRecord::Migration
  def up
    remove_column :causes, :closeout_date
  end

  def down
    add_column :causes, :closeout_date, :date
  end
end
