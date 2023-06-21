class TopicsController < ApplicationController

    def show
        @course = Course.find(params[:course_id])
        @topic = @course.topics.find(params[:id])
    end

    def new
        @course = Course.find(params[:course_id])
        @topic = @course.topics.new
    end

    def create
        @course = Course.find(params[:course_id])
        @topic = @course.topics.new(topic_params)
        if @topic.save
            redirect_to instructor_course_path(@course.instructor,@course)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @course = Course.find(params[:course_id])
        @topic = @course.topics.find(params[:id])
    end

    def update
        @course = Course.find(params[:course_id])
        @topic = @course.topics.find(params[:id])
        if @topic.update(topic_params)
            redirect_to course_path(@course)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @course = Course.find(params[:course_id])
        @topic = @course.topics.find(params[:id])
        @topic.destroy
        redirect_to course_path(@course), status: :see_other
    end


    def newnotes
        @course = Course.find(params[:course_id])
        @topic = @course.topics.find(params[:topic_id])        
    end

    def createnotes
        @course = Course.find(params[:course_id])
        @topic = @course.topics.find(params[:topic_id])
        notes = params[:notes]
        @topic.notes.attach(notes)
        if @topic.save
            redirect_to course_topic_path(@course,@topic),notice: "Notes Added successfully"
        else
            render :newnotes,status: :unprocessable_entity
        end        
    end

    def deletenotes
        @course = Course.find(params[:course_id])
        @topic = @course.topics.find(params[:topic_id])
        
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
end
