class AddingEmployeeIdInStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :employee_id, :integer
  end
end
