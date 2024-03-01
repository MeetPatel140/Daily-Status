class AddCheckinTimeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :checkin_at, :datetime
  end
end
