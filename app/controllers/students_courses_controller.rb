class StudentsCoursesController < ApplicationController
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
end
