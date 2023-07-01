ActiveAdmin.register Test do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :testable_type, :testable_id, :name, :questions
  #
  # or
  #
  permit_params do
    permitted = [:testable_type, :testable_id, :name, :questions]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  # ...

  index do
    selectable_column
    id_column
    column :name
    column :testable_type, as: 'Course/Topic'
    column :testable, as: "Course/Topic Name"
    column :questions do |model|
      questions = model.questions.map { |item| item['question'] }
      questions.each.with_index.map { |question, index| "Question #{index + 1}: #{question}" }.join('<br>').html_safe
    end
    column "Answers" do |model|
      questions = model.questions.map { |item| item['answer'] }
      questions.each.with_index.map { |question, index| "Answer for Question #{index + 1}: #{question}" }.join('<br>').html_safe
    end
    column "Mark" do |model|
      questions = model.questions.map { |item| item['mark'] }
      questions.each.with_index.map { |question, index| "Mark for Question #{index + 1}: #{question}" }.join('<br>').html_safe
    end
    column "Options" do |model|
      questions = model.questions.map { |item| item['mark'] }
      questions.each.with_index.map { 
        |question, index| 
          content = "Option for Question #{index+1}:<br>"
          content += "Option 1: #{question['0']} Option 2: #{question['1']} Option 3: #{question['2']} Option 4: #{question['3']}"
          raw(content)
      }.join('<br>').html_safe
    end
  end
  filter :testable_type, label: 'Test Type'
  filter :test_histories_student_id_eq, as: :select, label: 'Student', collection: -> { Student.joins(:user).pluck('users.name', 'students.id').uniq }

  scope :test_attended_which_more_than_5
  scope :test_attended_which_less_than_5
end
