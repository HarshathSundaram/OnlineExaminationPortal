class StudentsTestsController < ApplicationController
    def showcoursetests
        @student = Student.find(params[:student_id])
        @course = @student.courses.find(params[:course_id])
        @test = @course.tests.all
    end

    def takecoursetests
        @student = Student.find(params[:student_id])
        @course = @student.courses.find(params[:course_id])
        @test = @course.tests.find(params[:test_id])
    end

    def validatecoursetest
        @student = Student.find(params[:student_id])
        @course = @student.courses.find(params[:course_id])
        @test = @course.tests.find(params[:test_id])  
        answer_stu = params[:answer_stu]
        answer = params[:answer]
        mark = params[:mark]
        answer = Hash.new
        total_mark = 0
        mark_scored = 0
        @test.questions.each do |key, value|
            answer[key] = value['answer']
            if value['answer'] == answer_stu[key]
                mark_scored = mark_scored + (value['mark'].to_i)
            end
            total_mark = total_mark+ (value['mark'].to_i)
        end
        @test_history = TestHistory.new(mark_scored: mark_scored, total_mark: total_mark, answers: answer_stu, student: @student, test: @test)
        if @student.test_histories << @test_history
            redirect_to student_course_result_path(@student,@course,@test)
        end
    end

    def coursetestresult
        @student = Student.find(params[:student_id])
        @course = @student.courses.find(params[:course_id])
        @test = @course.tests.find(params[:test_id])
        @result = @student.test_histories.where(test_id: params[:test_id]).last
    end

    def showtopictests
        @student = Student.find(params[:student_id])
        @course = @student.courses.find(params[:course_id])
        @topic = @course.topics.find(params[:topic_id])
        @test = @topic.tests.all
    end

    def taketopictests
        @student = Student.find(params[:student_id])
        @course = @student.courses.find(params[:course_id])
        @topic = @course.topics.find(params[:topic_id])
        @test = @topic.tests.find(params[:test_id])
    end

    def validatetopictest
        @student = Student.find(params[:student_id])
        @course = @student.courses.find(params[:course_id])
        @topic = @course.topics.find(params[:topic_id])
        @test = @topic.tests.find(params[:test_id])
        answer_stu = params[:answer_stu]
        answer = params[:answer]
        mark = params[:mark]
        answer = Hash.new
        total_mark = 0
        mark_scored = 0
        @test.questions.each do |key, value|
            answer[key] = value['answer']
            if value['answer'] == answer_stu[key]
                mark_scored = mark_scored + (value['mark'].to_i)
            end
            total_mark = total_mark+ (value['mark'].to_i)
        end
        @test_history = TestHistory.new(mark_scored: mark_scored, total_mark: total_mark, answers: answer_stu, student: @student, test: @test)
        if @student.test_histories << @test_history
            redirect_to student_topic_result_path(@student,@course,@topic,@test)
        end
    end

    def topictestresult
        @student = Student.find(params[:student_id])
        @course = @student.courses.find(params[:course_id])
        @topic = @course.topics.find(params[:topic_id])
        @test = @topic.tests.find(params[:test_id])
        @result = @student.test_histories.where(test_id: params[:test_id]).last
        puts @result
    end
end
