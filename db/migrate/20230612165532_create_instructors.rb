class CreateInstructors < ActiveRecord::Migration[7.0]
  def change
    create_table :instructors do |t|
      t.string :name
      t.string :email
      t.string :gender
      t.string :designation

      t.timestamps
    end
  end
end
