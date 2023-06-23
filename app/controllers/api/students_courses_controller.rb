class StudentsCoursesController < ApplicationController
    # before_action :authenticate_user! 
    # before_action :is_student? 
    def index
        courses = Course.all
        student = Student.find_by(id:params[:student_id])
        unless student and courses
            render json:{message:"Error in fetching student and courses details"}, status: :not_found
        else
            render json:{"courses":courses,"student":student},status: :ok
        end
    end

    def showcourse
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        # unless current_user.userable == @student && @student.courses.include?(@course)
        #     flash[:alert] = "Unauthorized action"
        #     redirect_to student_path(current_user.userable)
        # end 
        unless student
            render json:{message:"Error in fetching student details"}, status: :not_found
        end
        unless course
            render json:{message:"No courses for the student #{student.user.name}"}, status: :no_content
        else
            render json:{"course":course,"student":student},status: :ok
        end
    end

    def showtopic
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        # unless current_user.userable == @student && @student.courses.include?(@course)
        #     flash[:alert] = "Unauthorized action"
        #     redirect_to student_path(current_user.userable)
        # end 
        unless student
            render json:{message:"Error in fetching student details"}, status: :not_found
        end
        unless course
            render json:{message:"No courses for the student #{student.user.name}"}, status: :no_content
        else
        unless topic
            render json:{message:"No topics available for the course #{course.name}"}, status: :no_content
        else
            render json:{"course":course,"student":student,"topic":topic},status: :ok
        end
    end

    def enroll
        student = Student.find_by(id:params[:student_id])
        course = Course.find_by(id:params[:course_id])
        if student.courses << course
            render json:{message:"#{student.user.name} successfully enrolled to a course"},status: :created
        else
            render json:{message:"Error in enrolling to a course "},status: :not_modified     
    end

    def unenroll
        student = Student.find_by(id:params[:student_id])
        course =student.courses.find_by(id:params[:course_id])
        # unless current_user.userable == @student && @student.courses.include?(@course)
        #     flash[:alert] = "Unauthorized action"
        #     redirect_to student_path(current_user.userable)
        # end 
        if student.courses.delete(course)
            render json:{message:"#{student.user.name} successfully unenrolled to a course"},status: :accepted
        else
            render json:{message:"Error in unenroll a course"},status: :not_modified
        end
    end

    private
    def is_student?
        unless user_signed_in? && current_user.userable_type == "Student"
            flash[:alert] = "Unauthorized action"
            redirect_to instructor_path(current_user.userable_id)
        end 
    end
    
end
