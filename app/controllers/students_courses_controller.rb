class StudentsCoursesController < ApplicationController
    before_action :authenticate_user!  
    before_action :is_student?
    def index
        @courses = Course.all
        @student = Student.find(params[:student_id])
    end

    def showcourse
        @student = Student.find(params[:student_id])
        @course = Course.find(params[:course_id])
    end

    def showtopic
        @student = Student.find(params[:student_id])
        @course = Course.find(params[:course_id])
        @topic = Topic.find(params[:topic_id])
    end

    def enroll
        @student = Student.find(params[:student_id])
        @course = Course.find(params[:course_id])
        @student.courses << @course
        redirect_to student_path(@student),  alert: "Successfully enrolled"     
    end

    def unenroll
        @student = Student.find(params[:student_id])
        @course = Course.find(params[:course_id])
        @student.courses.delete(@course)
        redirect_to student_path(@student), alert: "Sucessfully Unenrolled"
    end

    private
    def is_student?
        unless user_signed_in? && current_user.userable_type == "Student"
            flash[:alert] = "Unauthorized action"
            redirect_to instructor_path(current_user.userable_id)
        end
        student = Student.find(params[:student_id])
        unless current_user.userable == student
            flash[:alert] = "You are not allowed to access another student"
            redirect_to student_path(current_user.userable)
        end  
    end
end
