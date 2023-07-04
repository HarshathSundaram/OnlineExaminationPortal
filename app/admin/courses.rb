ActiveAdmin.register Course do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :category, :instructor_id
  #
  # or
  #
  permit_params do
    permitted = [:name, :category, :instructor_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  index do
    selectable_column
    id_column
    column :name
    column :instructor_id do |model|
      link_to model.instructor.user.name, admin_instructor_path(model.instructor_id)
    end
    column :category
    column 'Notes' do |model|
      if model.notes.attached?
        link_to model.notes.filename, rails_blob_path(model.notes, disposition: "attachment")
      else
        "No notes attached"
      end
    end
    actions 
  end

  filter :topics
  filter :tests_id_in, as: :select, label: 'Tests', collection: -> { Test.where(testable_type: 'Course').pluck(:name, :id) }
  filter :instructor_id_eq, as: :select, label: 'Instructor', collection: -> { Instructor.joins(:user).pluck('users.name', 'instructors.id') }
  filter :students_id_eq, as: :select, label: 'Student', collection: -> { Student.joins(:user).pluck('users.name', 'students.id').uniq }

  scope :course_with_greater_than_5_topic
  scope :course_with_less_than_5_topic

  
end
