class Api::CoursesController < Api::ApiController
    # before_action :authenticate_user!  
    # before_action :is_instructor?

    def show
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:id])
        if course
            render json:course, status: :ok            
        else
            render json:{message: "Course Not found"}, status: :not_found
        end
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
            rende json: course, status: :accepted
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
            rende json:{message: "Error in deleting course"}, status: :not_modified
    end

    def newnotes
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:course_id])       
    end

    def createnotes
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:course_id]) 
        notes = params[:notes]
        course.notes.attach(notes)
        if course.save
            render json:course.notes.filename, status: :created
        else
            render json:{message:"Could not save notes"},status: :unprocessable_entity
        end        
    end

    def deletenotes
        instructor = Instructor.find_by(id:params[:instructor_id])
        course = instructor.courses.find_by(id:params[:course_id])
        
        if course.notes.attached?
          if course.notes.purge
            render json:{message:"Notes deleted successfully"}, status: :see_other
          else
            render json:{message:"Notes not deleted"}, status: :not_modified
          end  
        else
          render json:{message:"No notes available"}, status: :no_content
        end
    end

    private
    def course_params
        params.require(:course).permit(:name,:category,:notes)
    end

    private
    def is_instructor?
        unless user_signed_in? && current_user.userable_type == "Instructor"
            flash[:alert] = "Unauthorized action"
            redirect_to student_path(current_user.userable_id)
        end

        course_id = params[:course_id] || params[:id] # Choose the appropriate parameter based on your route setup
        course = Course.find_by(id:course_id)
        
        unless course && course.instructor == current_user.userable
            flash[:alert] = "You are not the instructor of this course"
            redirect_to instructor_path(current_user.userable_id) # Redirect to a different path or handle accordingly
        end
    end
end
