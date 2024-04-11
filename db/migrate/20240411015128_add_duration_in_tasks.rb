class AddDurationInTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :duration, :integer
  end
end
