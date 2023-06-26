ActiveAdmin.register TestHistory do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :mark_scored, :total_mark, :test_id, :student_id, :answers
  #
  # or
  #
  permit_params do
    permitted = [:mark_scored, :total_mark, :test_id, :student_id, :answers]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
  actions :index, :show # Specify the actions you want to include
  # Override the "new" action to prevent creating new records
  controller do
    def new
      redirect_to admin_test_histories_path, alert: "New Test History creation is not allowed."
    end
  end 

  index do
    selectable_column
    id_column
    column :student_id do |model|
      link_to model.student.user.name, admin_student_path(model.student_id)
    end
    column "Test" do |model|
      model.test
    end
    column :mark_scored
    column :total_mark
    column "Student Answer" do |model|
      model.answers.map.with_index do |(_,answer),index|
        "Answer for Question #{index+1}: #{answer}"
      end.join("<br>").html_safe
    end
    column "Correct Answer" do|model|
      model.test.questions.map.with_index do|(_,answer),index|
        "Answer for Question #{index+1}: #{answer['answer']}"
      end .join("<br>").html_safe     
    end
  end

  filter :student_id_eq, as: :select, label: 'Student', collection: -> { Student.joins(:user).pluck('users.name', 'students.id').uniq }

  scope :mark_scored_greater_than_7
  scope :mark_scored_less_than_7

end
