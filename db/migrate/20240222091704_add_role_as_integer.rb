class AddRoleAsInteger < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :role, :integer, default: 0
  end
end
