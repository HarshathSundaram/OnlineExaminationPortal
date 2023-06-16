class TestsController < ApplicationController
    #Course
    def newcoursequestions
        @course = Course.find(params[:course_id])        
    end
    def createcoursequestions
        @course = Course.find(params[:course_id])
        name = params[:name]
        question = params[:question]
        options = params[:option]
        answer = params[:answer]
        mark = params[:mark]
        a = question.keys
        test = Hash.new
        a.each do |key|
            ans = Integer(answer[key])
            ans = ans-1
            test[key] = {
                "question" => question[key],
                "options" => options[key],
                "answer" => options[key][ans.to_s],
                "mark" => mark[key]
            }
        end
        @t = Test.new(name: name, questions: test)
        @course.tests << @t
        redirect_to test_course_path(@course)
    end
    def showcoursetests
        @course = Course.find(params[:course_id])
        @tests = @course.tests.all
    end
   
    def destroycoursetests
        @course = Course.find(params[:course_id])
        @test = @course.tests.find(params[:test_id])
        @test.destroy
        redirect_to test_course_path(@course)
    end


    #Topic
    def newtopicquestions
        @topic = Topic.find(params[:topic_id])
    end
    def createtopicquestions
        @topic = Topic.find(params[:topic_id])
        @course = @topic.course
        name = params[:name]
        question = params[:question]
        options = params[:option]
        answer = params[:answer]
        mark = params[:mark]
        a = question.keys
        test = Hash.new
        a.each do |key|
            ans = Integer(answer[key])
            ans = ans-1
            test[key] = {
                "question" => question[key],
                "options" => options[key],
                "answer" => options[key][ans.to_s],
                "mark" => mark[key]
            }
        end
        @t = Test.new(name: name, questions: test)
        @topic.tests << @t
        redirect_to course_topic_path(@course,@topic)
    end
    def showtopictests
        @topic = Topic.find(params[:topic_id])
        @tests = @topic.tests.all
    end
    def destroytopictests
        @topic = Topic.find(params[:topic_id])
        @test = @topic.tests.find(params[:test_id])
        @test.destroy
        redirect_to test_topic_path(@topic)
    end
end
