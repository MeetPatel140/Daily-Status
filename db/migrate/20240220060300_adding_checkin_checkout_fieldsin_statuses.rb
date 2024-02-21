class AddingCheckinCheckoutFieldsinStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :check_in, :datetime
    add_column :statuses, :check_out, :datetime
    add_column :statuses, :daily_report, :text
  end
end
