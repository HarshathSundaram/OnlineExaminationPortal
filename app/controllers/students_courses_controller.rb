class StudentsCoursesController < ApplicationController
    before_action :authenticate_user! 
    before_action :is_student? 
    def index
        @courses = Course.all
        @student = Student.find_by(id:params[:student_id])
    end

    def showcourse
        @student = Student.find_by(id:params[:student_id])
        @course = Course.find_by(id:params[:course_id])
        unless current_user.userable == @student && @student.courses.include?(@course)
            flash[:alert] = "Unauthorized action"
            redirect_to student_path(current_user.userable)
        end 
    end

    def showtopic
        @student = Student.find_by(id:params[:student_id])
        @course = Course.find_by(id:params[:course_id])
        @topic = Topic.find_by(id:params[:topic_id])
        unless current_user.userable == @student && @student.courses.include?(@course)
            flash[:alert] = "Unauthorized action"
            redirect_to student_path(current_user.userable)
        end 
    end

    def enroll
        @student = Student.find_by(id:params[:student_id])
        @course = Course.find_by(id:params[:course_id])
        @student.courses << @course
        redirect_to student_path(@student),  notice: "Successfully enrolled"     
    end

    def unenroll
        @student = Student.find_by(id:params[:student_id])
        @course = Course.find_by(id:params[:course_id])
        unless current_user.userable == @student && @student.courses.include?(@course)
            flash[:alert] = "Unauthorized action"
            redirect_to student_path(current_user.userable)
        end 
        @student.courses.delete(@course)
        redirect_to student_path(@student), alert: "Sucessfully Unenrolled"
    end

    private
    def is_student?
        unless user_signed_in? && current_user.userable_type == "Student"
            flash[:alert] = "Unauthorized action"
            redirect_to instructor_path(current_user.userable_id)
        end 
    end
    
end
