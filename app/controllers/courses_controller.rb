class CoursesController < ApplicationController
    before_action :authenticate_user!  
    before_action :is_instructor?

    def show
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.find(params[:id])
    end

    def new
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.new
    end

    def create
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.build(course_params)
    
        if @course.save
            redirect_to instructor_path(@instructor), notice: "Course created successfully."
        else
            render :new
        end
    end

    def edit
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.find(params[:id])
    end

    def update
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.find(params[:id])
        if @course.update(course_params)
            redirect_to instructor_path(@instructor)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.find(params[:id])
        @course.destroy
        redirect_to instructor_path(@instructor), status: :see_other
    end

    def newnotes
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.find(params[:course_id])       
    end

    def createnotes
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.find(params[:course_id]) 
        notes = params[:notes]
        @course.notes.attach(notes)
        if @course.save
            redirect_to instructor_course_path(@instructor,@course),notice: "Notes Added successfully"
        else
            render :newnotes,status: :unprocessable_entity
        end        
    end

    def deletenotes
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.find(params[:course_id])
        
        if @course.notes.attached?
          @course.notes.purge
          redirect_to instructor_course_path(@instructor,@course), notice: "Notes deleted successfully."
        else
          redirect_to instructor_course_path(@instructor,@course), alert: "No notes available to delete."
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
        course = Course.find(course_id)
        
        unless course && course.instructor == current_user.userable
            flash[:alert] = "You are not the instructor of this course"
            redirect_to instructor_path(current_user.userable_id) # Redirect to a different path or handle accordingly
        end
    end
end
