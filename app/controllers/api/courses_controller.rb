class Api::CoursesController < Api::ApiController 
    before_action :is_instructor?
    before_action :is_course_instructor? , except: [:coursesWithTopics, :coursesEnrolled]
    before_action :is_instructor_course?, except:[:coursesWithTopics, :coursesEnrolled, :create]
    def show
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:id])
        render json:course, status: :ok 
    end

    def new
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.new
        render json:{message: "New Course Creation"}
    end

    def create
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.build(course_params)
        if course.save
            render json:{message: "Course created successfully"}, status: :created
        else
            render json:{message: "Some Error in Creating Course"}, status: :unprocessable_entity 
        end
    end

    def edit
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:id])
        render json:{message: "Course Editing"}
    end

    def update
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:id])
        if course.update(course_params)
            render json: course, status: :accepted
        else
            render json:{message: "Error in updating content"}, status: :not_modified
        end
    end

    def destroy
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:id])
        if course.destroy
            render json:{message:"Course deleted successfully"}, status: :see_other
        else
            render json:{message: "Error in deleting course"}, status: :not_modified
        end
    end

    def newnotes
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:course_id])       
    end

    def createnotes
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:course_id])
        notes = params[:notes]
        puts(notes)
        course.notes.attach(notes)
        if course.save
            render json:course.notes, status: :ok
        else
            render json:{message:"Could not save notes"},status: :unprocessable_entity
        end       
    end

    def deletenotes
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:course_id])
        if course.notes.attached?
            course.notes.purge
            render json:{message:"Notes deleted successfully"}, status: :see_other 
        else
            render json:{message:"No notes available"}, status: :no_content
        end
    end

    def coursesWithTopics
        course_name  = []
        courses = Course.all
        count = params[:count].to_i  
        courses.each do |course|
            if course.topics.count == count
                course_name << course.name
            end
        end
        if course_name.blank?
            render json:{message:"There is no courses with #{count} topic"},status: :internal_server_error
        else
            render json:course_name,status: :ok
        end
    end

    def coursesEnrolled
        course_name  = []
        courses = Course.all
        count = params[:count].to_i  
        courses.each do |course|
            if course.students.count == count
                students=course.students
                student_names = []
                students.each do |student|
                    student_names<<student.user.name
                end
                course_name << {"Course Name": course.name, "Students": student_names}
            end
        end
        if course_name.blank?
            render json:{message:"There is no courses enrolled by #{count} studnets"},status: :internal_server_error
        else
            render json:course_name,status: :ok
        end
    end

    private
    def course_params
        params.require(:course).permit(:name,:category,:notes)
    end

    private
    def is_instructor?
        unless user_signed_in? 
            render json:{message:"Unauthorized action"},status: :unauthorized
        end  
    end

    private 
    def is_course_instructor?
        instructor = Instructor.find_by(id:params[:instructor_id])
        if instructor
            unless instructor== current_user.userable && current_user.userable_type == "Instructor"
                render json:{message:"You are not allowed to access another instructor"}, status: :forbidden
            end 
        else
            render json:{message:"Instructor is not found"}, status: :not_found
        end
    end

    private 
    def is_instructor_course?
        course_id = params[:course_id] || params[:id]
        course = Course.find_by(id:course_id)
        if course
            unless current_user.userable == course.instructor
                render json:{message:"You are not instructor of this course"}, status: :forbidden
            end
        else
            render json:{message:"Course not found"}, status: :not_found
        end
    end
end
