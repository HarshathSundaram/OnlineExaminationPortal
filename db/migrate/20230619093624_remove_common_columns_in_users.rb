class RemoveCommonColumnsInUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :students, :name
    remove_column :instructors, :name
    remove_column :students, :email
    remove_column :instructors, :email
    remove_column :students, :gender
    remove_column :instructors, :gender
  end
end
