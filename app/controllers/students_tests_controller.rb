class StudentsTestsController < ApplicationController
    before_action :authenticate_user! 
    before_action :is_student?
    before_action :is_student_course? 
    before_action :is_course_topic?, except: [:showcoursetests,:takecoursetests,:validatecoursetest, :coursetestresult]
    before_action :is_course_test?, except: [:showcoursetests,:showtopictests,:taketopictests,:validatetopictest,:topictestresult]
    before_action :is_topic_test?, except: [:showcoursetests, :showtopictests, :takecoursetests, :validatecoursetest, :coursetestresult]
    def showcoursetests
        @student = Student.find_by(id:params[:student_id])
        @course = @student.courses.find_by(id:params[:course_id])
        @test = @course.tests.all
    end

    def takecoursetests
        @student = Student.find_by(id:params[:student_id])
        @course = @student.courses.find_by(id:params[:course_id])
        @test = @course.tests.find_by(id:params[:test_id])
    end

    def validatecoursetest
        @student = Student.find_by(id:params[:student_id])
        @course = @student.courses.find_by(id:params[:course_id])
        @test = @course.tests.find_by(id:params[:test_id])  
        answer_stu = params[:answer_stu]
        answer = params[:answer]
        mark = params[:mark]
        answer = Hash.new
        total_mark = 0
        mark_scored = 0
        p @test.questions
        @test.questions.each.with_index do |value,index|
            p value['answer'] == answer_stu[index.to_s]
            if value['answer'] == answer_stu[index.to_s]
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
        @student = Student.find_by(id:params[:student_id])
        @course = @student.courses.find_by(id:params[:course_id])
        @test = @course.tests.find_by(id:params[:test_id])
        @result = @student.test_histories.where(test_id: params[:test_id]).last
    end

    def showtopictests
        @student = Student.find_by(id:params[:student_id])
        @course = @student.courses.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        @tests = @topic.tests.all
    end

    def taketopictests
        @student = Student.find_by(id:params[:student_id])
        @course = @student.courses.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        @test = @topic.tests.find_by(id:params[:test_id])
    end

    def validatetopictest
        @student = Student.find_by(id:params[:student_id])
        @course = @student.courses.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        @test = @topic.tests.find_by(id:params[:test_id])
        answer_stu = params[:answer_stu]
        answer = params[:answer]
        mark = params[:mark]
        answer = Hash.new
        total_mark = 0
        mark_scored = 0
        @test.questions.each.with_index do |value,index|
            if value['answer'] == answer_stu[index.to_s]
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
        @student = Student.find_by(id:params[:student_id])
        @course = @student.courses.find_by(id:params[:course_id])
        @topic = @course.topics.find_by(id:params[:topic_id])
        @test = @topic.tests.find_by(id:params[:test_id])
        @result = @student.test_histories.where(test_id: params[:test_id]).last
        puts @result
    end
    private
    def is_student?
        unless user_signed_in? && current_user.userable_type == "Student"
            flash[:alert] = "Unauthorized action"
            redirect_to instructor_path(current_user.userable_id)
        end 
    end
    private
    def is_student_course?
        student = Student.find_by(id:params[:student_id])
        course = Course.find_by(id:params[:course_id])
        if course
            unless student.courses.include?(course)
                flash[:alert] = "You have not enrolled in this course"
                redirect_to student_path(student)
            end
        else
            flash[:alert] = "Course not found"
            redirect_to student_path(student)
        end
    end
    private
    def is_course_topic?
        course = Course.find_by(id:params[:course_id])
        topic = Topic.find_by(id:params[:topic_id])
        if topic
            unless course.topics.include?(topic)
                flash[:alert] = "#{course.name} is not having this topic #{topic.name}"
                redirect_to student_course_course_path(params[:student_id],course) 
            end
        else
            flash[:alert] = "Topic not found"
            redirect_to student_course_course_path(params[:student_id],course)
        end
    end
    private
    def is_course_test?
        course = Course.find_by(id:params[:course_id])
        test = Test.find_by(id:params[:test_id])
        if test
            unless course.tests.include?(test)
                flash[:alert] = "#{course.name} has not having this test #{test.name}"
                redirect_to students_course_tests_path(params[:student_id],course)
            end
        else
            flash[:alert] = "Test not found"
            redirect_to students_course_tests_path(params[:student_id],course)
        end
    end
    private
    def is_topic_test?
        topic = Topic.find_by(id:params[:topic_id])
        test = Test.find_by(id:params[:test_id])
        if test
            unless topic.tests.include?(test)
                flash[:alert] = "#{topic.name} has not having this test #{test.name}"
                redirect_to students_topic_tests_path(params[:student_id],params[:course_id],topic)
            end
        else
            flash[:alert] = "Test not found"
            redirect_to students_topic_tests_path(params[:student_id],params[:course_id],topic)
        end
    end
end
