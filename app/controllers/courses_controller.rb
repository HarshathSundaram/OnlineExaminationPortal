class CoursesController < ApplicationController

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
end
