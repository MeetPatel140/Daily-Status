class AddStatusinStatusesTable < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :status, :string, default: 'pending'
  end
end
