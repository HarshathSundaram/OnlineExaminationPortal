class TopicsController < ApplicationController
    before_action :authenticate_user!  
    before_action :is_instructor?
    before_action :is_instructor_course?
    before_action :is_course_topic? ,except: [:new,:create]
    def show
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:id])
    end

    def new
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.new
    end

    def create
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.new(topic_params)
        if @topic.save
            redirect_to instructor_course_path(@course.instructor,@course), notice: "Topics created successfully"
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:id])
    end

    def update
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:id])
        if @topic.update(topic_params)
            redirect_to instructor_course_path(@course.instructor,@course), notice: "Topic is updated!!!"
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:id])
        @topic.destroy
        redirect_to instructor_course_path(@course.instructor,@course), status: :see_other, alert: "Topic is deleted!!!"
    end


    def newnotes
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])        
    end

    def createnotes
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        notes = params[:notes]
        @topic.notes.attach(notes)
        if @topic.save
            redirect_to course_topic_path(@course,@topic),notice: "Notes Added successfully"
        else
            render :newnotes,status: :unprocessable_entity
        end        
    end

    def deletenotes
        @course = Course.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        
        if @topic.notes.attached?
          @topic.notes.purge
          redirect_to course_topic_path(@course, @topic), notice: "Notes deleted successfully."
        else
          redirect_to course_topic_path(@course, @topic), alert: "No notes available to delete."
        end
    end
      



    private
    def topic_params
        params.require(:topic).permit(:name,:description,:notes)
    end

    private
    def is_instructor?
        unless user_signed_in? && current_user.userable_type == "Instructor"
            flash[:alert] = "Unauthorized action"
            redirect_to student_path(current_user.userable_id)
        end
    end

    private
    def is_instructor_course?
        course = Course.find_by(id:params[:course_id])
        if course
            unless course.instructor == current_user.userable
                flash[:alert] = "You are not allowed to access another instructor course"
                redirect_to instructor_path(current_user.userable)
            end
        else
            flash[:alert] = "Course not found"
            redirect_to instructor_path(current_user.userable)
        end
    end

    private 
    def is_course_topic?
        course = Course.find_by(id:params[:course_id])
        topic_id = params[:topic_id] || params[:id]
        topic = Topic.find_by(id:topic_id)
        if topic
            unless course && course.topics.include?(topic)
                flash[:alert] = "Topic not belongs to this course"
                redirect_to instructor_course_path(current_user.userable,course)
            end
        else
            flash[:alert] = "Topic not found"
            redirect_to instructor_course_path(current_user.userable,course)
        end
    end

end
