class CreateCheckouts < ActiveRecord::Migration[7.1]
  def change
    create_table :checkouts do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :checked_out_at, null: false

      t.timestamps
    end
  end
end
