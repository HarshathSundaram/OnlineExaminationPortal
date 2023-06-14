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
            redirect_to course_path(@course)
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

    private
    def topic_params
        params.require(:topic).permit(:name,:description)
    end
end
