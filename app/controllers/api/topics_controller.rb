class Api::TopicsController < Api::ApiController
    before_action :is_instructor?
    before_action :is_instructor_course?
    before_action :is_course_topic?, except: [:create]

    def show
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:id])   
        render json:topic, status: :ok
    end

    def new
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.new
    end

    def create
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.new(topic_params)
        if topic.save
            render json:topic,status: :created
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
            render json:{message:"Notes Created Successfully"},status: :ok
        else
            render json:{message:"Could Not Save Notes"},status: :unprocessable_entity
        end          
    end

    def deletenotes
        course = Course.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        if topic.notes.attached?
            topic.notes.purge
            render json:{message:"Notes deleted successfully"}, status: :see_other 
        else
            render json:{message:"No notes available"}, status: :no_content
        end
    end
      
    private
    def topic_params
        params.require(:topic).permit(:name,:description,:notes)
    end

    private
    def is_instructor?
        unless user_signed_in? 
            render json:{message:"Unauthorized action"},status: :unauthorized
        end  
    end

    private
    def is_instructor_course?
        course = Course.find_by(id:params[:course_id])
        if course
            unless course.instructor == current_user.userable
                render json:{message:"You are not the instructor of this course"}, status: :forbidden
            end
        else
            render json:{message:"Course not find"}, status: :not_found
        end
    end

    private
    def is_course_topic?
        course = Course.find_by(id:params[:course_id])
        topic_id = params[:topic_id] || params[:id]
        topic = Topic.find_by(id:topic_id)
        if topic
            unless course.topics.include?(topic)
                render json:{message:"Topic is not in the course"}, status: :forbidden
            end
        else
            render json:{message:"Topic not found"}, status: :not_found
        end        
    end
end
