class RemoveAndAddCourseReferenceInTopic < ActiveRecord::Migration[7.0]
  def change
    remove_column :topics, :courses_id
    add_reference :topics, :course, index: true
  end
end
