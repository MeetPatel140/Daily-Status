class ChangeEmployeeIdToUserIdInStatuses < ActiveRecord::Migration[7.1]
  def change
    def up
      change_table :statuses do |t|
        t.change :user_id, :integer
      end
    end
  end

  def down
    def down
      change_table :statuses do |t|
        t.change :employee_id, :integer
      end
    end
  end
end
