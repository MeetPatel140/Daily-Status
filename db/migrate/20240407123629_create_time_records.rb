class CreateTimeRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :time_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :check_in_at
      t.datetime :check_out_at
      t.integer :duration_in_seconds, default: 0

      t.timestamps
    end
  end
end
