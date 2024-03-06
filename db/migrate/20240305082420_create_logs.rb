class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.datetime :timestamp
      t.string :action

      t.timestamps
    end
  end
end
