class AddDefaultRoleForUsers < ActiveRecord::Migration[7.1]
  def up
    change_table :users do |t|
      t.change :role, :string, default: 'employee'
    end
  end

  def down
    change_table :users do |t|
      t.change :role, :string
    end
  end
end
