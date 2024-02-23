class AddRoleInEmployeeTable < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :role, :string
  end
end
