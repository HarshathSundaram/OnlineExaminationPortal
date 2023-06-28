class Api::StudentsCoursesController < Api::ApiController
    before_action :is_student? 
    before_action :is_student_course?, except: [:enroll,:index]
    before_action :is_course_topic?, only: [:showtopic]
    def index
        courses = Course.all
        unless courses
            render json:{message:"Error in getting courses"}, status: :internal_server_error
        else
            student = Student.find_by(id:params[:student_id])
            render json:{"courses":courses,"student":student.courses},status: :ok
        end
        
    end

    def showcourse
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        render json:{"course":course,"student":student},status: :ok    
    end

    def showtopic
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        render json:{"course":course,"student":student,"topic":topic},status: :ok    
    end

    def enroll
        student = Student.find_by(id:params[:student_id])
        course = Course.find_by(id:params[:course_id])
        if course
            if student.courses.include?(course)
                render json:{message:"You are already enrolled in this course"}, status: :bad_request
            else
                if student.courses << course
                    render json:{message:"#{student.user.name} successfully enrolled to a course"},status: :created
                else
                    render json:{message:"Error in enrolling to a course "},status: :not_modified 
                end
            end
        else
            render json:{message:"Error in getting course"}, status: :internal_server_error
        end   
    end

    def unenroll
        student = Student.find_by(id:params[:student_id])
        course =student.courses.find_by(id:params[:course_id]) 
        if student.courses.delete(course)
            render json:{message:"#{student.user.name} successfully unenrolled to a course"},status: :accepted
        else
            render json:{message:"Error in unenroll a course"},status: :not_modified
        end   
    end

    private
    def is_student?
        student = Student.find_by(id:params[:student_id])
        unless user_signed_in? 
            render json:{message:"Unauthorized action"}, status: :unauthorized
        end 
        if student 
            unless current_user.userable == student&& current_user.userable_type == "Student"
                render json:{message: "You have no access to this student"}, status: :forbidden
            end
        else
            render json:{message:"Student not found"},status: :not_found
        end
    end

    private
    def is_student_course?
        student = Student.find_by(id:params[:student_id])
        course = Course.find_by(id:params[:course_id])
        if course
            unless student.courses.include?(course)
                render json:{message:"You have not enrolled in this course"},status: :forbidden
            end
        else
            render json:{message:"Course not found"},status: :not_found
        end
    end

    private
    def is_course_topic?
        course = Course.find_by(id:params[:course_id])
        topic = Topic.find_by(id:params[:topic_id])
        if topic
            unless course.topics.include?(topic)
                render json:{message:"This topic is not in this course"},status: :forbidden
            end
        else
            render json:{message:"Topic not found"},status: :not_found            
        end       
    end
end
