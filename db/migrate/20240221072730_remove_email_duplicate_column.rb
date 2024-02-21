class RemoveEmailDuplicateColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :employees, :email
    remove_column :employees, :password_digest
  end
end
