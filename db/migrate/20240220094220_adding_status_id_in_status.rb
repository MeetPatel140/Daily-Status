class AddingStatusIdInStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :user_id, :integer
  end
end
