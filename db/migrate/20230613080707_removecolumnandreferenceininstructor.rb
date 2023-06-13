class Removecolumnandreferenceininstructor < ActiveRecord::Migration[7.0]
  def change
    remove_column :courses, :instructors_id
    add_reference :courses, :instructor, index: true
  end
end
