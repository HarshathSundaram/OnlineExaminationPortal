class CoursesController < ApplicationController
    def new
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.new
    end

    def create
        @instructor = Instructor.find(params[:instructor_id])
        @course = @instructor.courses.new(course_params)
        if @course.save
            redirect_to instructor_path(@instructor)
        else
            render :new, status: :unprocessable_entity
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

    private
    def course_params
        params.require(:course).permit(:name,:category)
    end
end
