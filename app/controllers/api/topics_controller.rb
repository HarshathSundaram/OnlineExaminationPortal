class Api::TopicsController < Api::ApiController
    # before_action :authenticate_user!  
    # before_action :is_instructor?
    def show
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:id])
        unless course
            render json:{message:"Error in fetching course"}, status: :not_found
        end
        if topic
            render json:topic, status: :ok
        else
            render json:{message:"No topic available for the course #{course.name}"},status: :no_content
        end
    end

    def new
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.new
    end

    def create
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.new(topic_params)
        if topic.save
            render json:topic,status: :ok
        else
            render json:{message:"Error while creating topic"}, status: :unprocessable_entity
        end
    end

    def edit
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:id])
    end

    def update
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:id])
        if topic.update(topic_params)
            render json:topic, status: :accepted
        else
            render json:{message:"Error while updating topic"}, status: :not_modified
        end
    end

    def destroy
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:id])
        if topic.destroy
            render json:{message:"Topic with id: #{params[:id].to_i} is destroyes successfully"}, status: :see_other
        else
            render json:{message:"Error while destroying topic with id: #{params[:id].to_i}"}, status: :not_modified
        end
    end


    def newnotes
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])        
    end

    def createnotes
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        notes = params[:notes]
        topic.notes.attach(notes)
        if topic.save
            redirect_to course_topic_path(course,topic),notice: "Notes Added successfully"
        else
            render :newnotes,status: :unprocessable_entity
        end        
    end

    def deletenotes
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        
        if topic.notes.attached?
          topic.notes.purge
          redirect_to course_topic_path(course, topic), notice: "Notes deleted successfully."
        else
          redirect_to course_topic_path(course, topic), alert: "No notes available to delete."
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

        course_id = params[:course_id] || params[:id] # Choose the appropriate parameter based on your route setup
        course = Course.find_by(id:course_id)
        
        unless course && course.instructor == current_user.userable
            flash[:alert] = "You are not the instructor of this course"
            redirect_to instructor_path(current_user.userable_id) # Redirect to a different path or handle accordingly
        end
    end

end
