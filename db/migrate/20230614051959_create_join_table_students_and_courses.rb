class CreateJoinTableStudentsAndCourses < ActiveRecord::Migration[7.0]
  def change
    create_join_table :students, :courses do |c|
      c.index [:student_id, :course_id]
    end
  end
end
