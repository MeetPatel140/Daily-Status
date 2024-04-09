class AddingCheckinCheckoutFieldsinStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :daily_report, :text
  end
end
