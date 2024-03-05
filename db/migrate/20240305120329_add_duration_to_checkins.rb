class AddDurationToCheckins < ActiveRecord::Migration[7.1]
  def change
    add_column :checkins, :duration, :integer
  end
end
