class StudentsCoursesController < ApplicationController
    before_action :authenticate_user! 
    before_action :is_student?
    before_action :is_student_course?, except: [:index, :enroll]
    before_action :enrollment?, only: [:enroll] 
    before_action :is_course_topic?, only: [:showtopic]
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
        student = Student.find_by(id:params[:student_id])
        unless user_signed_in? && current_user.userable_type == "Student"
            flash[:alert] = "Unauthorized action"
            redirect_to instructor_path(current_user.userable_id)
        end
        
        unless student == current_user.userable
            flash[:alert] = "You are not allowed to access another student"
            redirect_to student_path(current_user.userable)
        end
    end

    private
    def is_student_course?
        student = Student.find_by(id:params[:student_id])
        course = Course.find_by(id:params[:course_id])
        if course
            unless student.courses.include?(course)
                flash[:alert] = "You have not enrolled into this course"
                redirect_to student_path(student)
            end 
        else
            flash[:alert] = "Course not found"
            redirect_to student_path(student)
        end    
    end

    private
    def enrollment?
        student = Student.find_by(id:params[:student_id])
        course = Course.find_by(id:params[:course_id])
        if student.courses.include?(course)
            flash[:alert] = "You have already enrolled in this course"
            redirect_to student_path(student)
        end        
    end

    private
    def is_course_topic?
        course = Course.find_by(id:params[:course_id])
        topic = Topic.find_by(id:params[:topic_id])
        if topic
            unless course.topics.include?(topic)
                flash[:alert] = "#{course.name} is not having this topic #{topic.name}"
                redirect_to student_course_course_path(params[:student_id],course)
            end
        else
            flash[:alert] = "Topic not found"
            redirect_to student_course_course_path(params[:student_id],course)
        end
    end
    
end
