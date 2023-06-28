class TestsController < ApplicationController
    before_action :authenticate_user! 
    before_action :is_instructor? 
    before_action :is_instructor_course?
    #Course
    def newcoursequestions
        @course = Course.find_by(id:params[:course_id])        
    end
    def createcoursequestions
        @course = Course.find_by(id:params[:course_id])
        name = params[:name]
        name = params[:name]
        question = params[:test][:question]
        options = params[:test][:option]
        answer = params[:test][:answer]
        mark = params[:test][:mark]
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
        @course = Course.find_by(id:params[:course_id])
        @test = Test.find_by(id:params[:test_id])
    end
    def updatecoursequestions
        @course = Course.find_by(id:params[:course_id])
        @test = @course.tests.find_by(id:params[:test_id])
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
            redirect_to test_course_path(@course, @test)
        end
    end

    def showcoursetests
        @course = Course.find_by(id:params[:course_id])
        @tests = @course.tests.all
    end
   
    def destroycoursetests
        @course = Course.find_by(id:params[:course_id])
        @test = @course.tests.find_by(id:params[:test_id])
        @test.destroy
        redirect_to test_course_path(@course)
    end


    #Topic
    def newtopicquestions
        @course = Course.find_by(id: params[:course_id])
        @topic = @course.topics.find_by(id: params[:topic_id])
    end
    def createtopicquestions
        @course = Course.find_by(id: params[:course_id])
        @topic = @course.topics.find_by(id: params[:topic_id])
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
        @course = Course.find_by(id: params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        @test = Test.find_by(id:params[:test_id])
    end
    def updatetopicquestions
        @course = Course.find_by(id: params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        @test = @topic.tests.find_by(id:params[:test_id])
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
            redirect_to test_topic_path(@course,@topic, @test)
        end
    end

    def showtopictests
        @course = Course.find_by(id: params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        @tests = @topic.tests.all
    end
    def destroytopictests
        @course = Course.find_by(id: params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        @test = @topic.tests.find_by(id:params[:test_id])
        @test.destroy
        redirect_to test_topic_path(@course,@topic)
    end

    private
    def is_instructor?
        unless user_signed_in? && current_user.userable_type == "Instructor"
            flash[:alert] = "Unauthorized action"
            redirect_to student_path(current_user.userable)
        end
    end
    
    private
    def is_instructor_course?
        course = Course.find_by(id:params[:course_id])
        if course
            unless current_user.userable == course.instructor
                flash[:alert] = "You are not allowed to access another instructor course"
                redirect_to instructor_course_path(course.instructor,course)
            end
        else
            flash[:alert] = "Course not found"
            redirect_to instructor_path(current_user.userable)
        end        
    end
end
