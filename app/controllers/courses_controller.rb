class CoursesController < ApplicationController
    before_action :authenticate_user!  
    before_action :is_instructor?
    before_action :is_course_instructor?
    before_action :is_instructor_course? , except: [:new, :create]

    def show
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.find_by(id:params[:id])
    end

    def new
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.new
    end

    def create
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.build(course_params)
    
        if @course.save
            redirect_to instructor_path(@instructor), notice: "Course created successfully."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.find_by(id:params[:id])
    end

    def update
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.find_by(id:params[:id])
        if @course.update(course_params)
            redirect_to instructor_path(@instructor), notice: "Course is updated!!!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.find_by(id:params[:id])
        @course.destroy
        redirect_to instructor_path(@instructor), status: :see_other, alert: "Course is deleted!!!"
    end

    def newnotes
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.find_by(id:params[:course_id])       
    end

    def createnotes
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.find_by(id:params[:course_id]) 
        notes = params[:notes]
        @course.notes.attach(notes)
        if @course.save
            redirect_to instructor_course_path(@instructor,@course),notice: "Notes Added successfully"
        else
            render :newnotes,status: :unprocessable_entity
        end        
    end

    def deletenotes
        @instructor = Instructor.find_by(id:params[:instructor_id])
        @course = @instructor.courses.find_by(id:params[:course_id])
        
        if @course.notes.attached?
          @course.notes.purge
          redirect_to instructor_course_path(@instructor,@course),alert: "Notes deleted!!"
        else
          redirect_to instructor_course_path(@instructor,@course), alert: "No notes available to delete."
        end
    end

    private
    def course_params
        params.require(:course).permit(:name,:category)
    end

    private
    def is_instructor?
        unless user_signed_in? && current_user.userable_type == "Instructor"
            flash[:alert] = "Unauthorized action"
            redirect_to student_path(current_user.userable_id)
        end
    end

    private
    def is_course_instructor?
        instructor = Instructor.find_by(id:params[:instructor_id])
        if instructor
            unless instructor == current_user.userable
                flash[:alert] = "You are not allowed to access other instructor"
                redirect_to instructor_path(current_user.userable)
            end
        else
            flash[:alert] = "Instructor not found"
            redirect_to instructor_path(current_user.userable)
        end
    end

    private
    def is_instructor_course?
        course_id = params[:course_id] || params[:id] # Choose the appropriate parameter based on your route setup
        course = Course.find_by(id:course_id)
        
        unless course && course.instructor == current_user.userable
            flash[:alert] = "You are not the instructor of this course"
            redirect_to instructor_path(current_user.userable_id) # Redirect to a different path or handle accordingly
        end
    end
end
