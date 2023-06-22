ActiveAdmin.register Topic do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :course_id
  #
  # or
  #
  permit_params do
    permitted = [:name, :description, :course_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :course do |model|
      link_to model.course.name, admin_course_path(model.course)
    end
    column 'Notes' do |model|
      if model.notes.attached?
        link_to model.notes.filename, rails_blob_path(model.notes, disposition: "attachment")
      else
        "No notes attached"
      end
    end
  end
  filter :tests_id_in, as: :select, label: 'Tests', collection: -> { Test.where(testable_type: 'Course').pluck(:name, :id) }
  filter :course 
end
