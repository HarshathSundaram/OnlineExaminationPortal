# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    section strong{"Students"} do 
      table_for Student.limit(3) do
        column "Name" do |model|
          link_to model.user.name, admin_student_path(model)
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
      strong {link_to "View all Students" , admin_students_path }
    end

    br

    section strong{"Instructors"} do 
      table_for Instructor.limit(3) do
        column "Name" do |model|
          link_to model.user.name, admin_instructor_path(model)
        end
        column "Email" do |model|
          model.user.email
        end
        column "Gender" do |model|
          model.user.gender
        end
        column :designation
      end
      strong {link_to "View all Instructors" , admin_instructors_path }
    end

    br

    section strong{"Courses"} do 
      table_for Course.limit(3) do
        column :name do |model|
          link_to model.name, admin_course_path(model)
        end
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
      end
      strong {link_to "View all Courses" , admin_courses_path }
    end

    br

    section strong{"Topics"} do 
      table_for Topic.limit(3) do
        column :name do |model|
          link_to model.name, admin_topic_path(model)
        end
        column :course do |model|
          link_to model.course.name, admin_course_path(model.course)
        end
        column :description 
        column 'Notes' do |model|
          if model.notes.attached?
            link_to model.notes.filename, rails_blob_path(model.notes, disposition: "attachment")
          else
            "No notes attached"
          end
        end
      end
      strong {link_to "View all Topics" , admin_topics_path }
    end


    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
