ActiveAdmin.register Student do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :department, :year
  #
  # or
  #
  permit_params do
    permitted = [:department, :year]
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
    column :department
    column :year
  end

  filter :courses
  filter :test_histories_test_id_eq, as: :select, label: 'Test Name', collection: -> { Test.pluck(:name,:id) }
  scope :student_enrolled_more_than_5_course
  scope :student_enrolled_less_than_5_course
end
