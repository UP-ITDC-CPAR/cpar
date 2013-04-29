class AddWithRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :with_role, :boolean, default: false
  end
end
