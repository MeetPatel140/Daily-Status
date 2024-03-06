class AddDurationToCheckouts < ActiveRecord::Migration[7.1]
  def change
    add_column :checkouts, :duration, :integer
  end
end
