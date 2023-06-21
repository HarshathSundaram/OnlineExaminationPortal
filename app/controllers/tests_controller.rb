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
    def showcoursequestions
        @course = Course.find(params[:course_id])
        @test = Test.find(params[:test_id])
    end
    def updatecoursequestions
        @course = Course.find(params[:course_id])
        @test = @course.tests.find(params[:test_id])
        name = params[:name]
        question = params[:question]
        options = params[:option]
        answer = params[:answer]
        mark = params[:mark]
        a = question.keys
        ques = Hash.new
        a.each do |key|
            ans = Integer(answer[key])
            ans = ans-1
            puts ans
            puts "Option Answer"
            puts options[key][ans.to_s]
            ques[key] = {
                "question" => question[key],
                "options" => options[key],
                "answer" => options[key][ans.to_s],
                "mark" => mark[key]
            }
        end
        puts(ques)
        @new_t = Test.new(name: name, questions: ques)
        if @test.update({name:name,questions:ques})
            redirect_to test_course_path(@course,@test)
        end
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

    def showtopicquestions
        @topic = Topic.find(params[:topic_id])
        @test = Test.find(params[:test_id])
    end
    def updatetopicquestions
        @topic = Topic.find(params[:topic_id])
        @test = @topic.tests.find(params[:test_id])
        name = params[:name]
        question = params[:question]
        options = params[:option]
        answer = params[:answer]
        mark = params[:mark]
        a = question.keys
        ques = Hash.new
        a.each do |key|
            ans = Integer(answer[key])
            ans = ans-1
            puts ans
            puts "Option Answer"
            puts options[key][ans.to_s]
            ques[key] = {
                "question" => question[key],
                "options" => options[key],
                "answer" => options[key][ans.to_s],
                "mark" => mark[key]
            }
        end
        puts(ques)
        @new_t = Test.new(name: name, questions: ques)
        if @test.update({name:name,questions:ques})
            if !@test.test_histories.blank?
                @test_histories = @test.test_histories.all
                @test_histories.each do |history|
                  total_mark = 0
                  mark_scored = 0
                  answer_stu = history.answers
                  ques.each do |key, value|
                    total_mark = total_mark + (value['mark'].to_i)
                    if value['answer'] == answer_stu[key]
                      mark_scored = mark_scored + (value['mark'].to_i)
                    end
                    history.update({ mark_scored: mark_scored, total_mark: total_mark })
                  end
                end
              end
            redirect_to test_topic_path(@topic, @test)
        end
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
