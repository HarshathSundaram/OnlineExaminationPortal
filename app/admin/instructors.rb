ActiveAdmin.register Instructor do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :designation
  #
  # or
  #
  permit_params do
    permitted = [:designation]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  index do
    selectable_column
    id_column
    column "Name" do |model|
      model.user.name
    end
    column "Email" do |model|
      model.user.email
    end
    column "Gender" do |model|
      model.user.gender
    end
    column :designation
  end 

  filter :courses
  filter :designation, as: :select

  scope :instructor_with_more_than_5_course do |instructors|
    instructors.instructor_with_more_than_5_course
  end

  scope :instructor_with_less_than_5_course do |instructors|
    instructors.instructor_with_less_than_5_course
  end
end
