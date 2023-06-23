class Api::StudentsTestsController < Api::ApiController
    # before_action :authenticate_user!  
    def showcoursetests
        student = Student.find(params[:student_id])
        course = @student.courses.find_by(id:params[:course_id])
        tests = @course.tests.all
        unless student and course and tests
            render json:{message:"Error in getting student, course, and tests details"},status: :not_found
        else
            render json:{"Student": student,"Course": course,"tests": tests},status: :ok
        end
    end

    def takecoursetests
        student = Student.find(params[:student_id])
        course = @student.courses.find(params[:course_id])
        test = @course.tests.find(params[:test_id])
        unless student and course and test
            render json:{message:"Error in getting student, course, and test details"},status: :not_found
        else
            render json:{"Student": student,"Course": course,"test": test},status: :ok
        end
    end

    def validatecoursetest
        student = Student.find(params[:student_id])
        course = @student.courses.find(params[:course_id])
        test = @course.tests.find(params[:test_id])  
        answer_stu = params[:answer_stu]
        answer = params[:answer]
        mark = params[:mark]
        answer = Hash.new
        total_mark = 0
        mark_scored = 0
        test.questions.each do |key, value|
            answer[key] = value['answer']
            if value['answer'] == answer_stu[key]
                mark_scored = mark_scored + (value['mark'].to_i)
            end
            total_mark = total_mark+ (value['mark'].to_i)
        end
        test_history = TestHistory.new(mark_scored: mark_scored, total_mark: total_mark, answers: answer_stu, student: @student, test: @test)
        if student.test_histories << test_history
            render json:test_history,status: :created
        else
            render json:{message:"Error in recording test history"},status: :not_modified
        end
    end

    def coursetestresult
        student = Student.find(params[:student_id])
        course = @student.courses.find(params[:course_id])
        test = @course.tests.find(params[:test_id])
        result = @student.test_histories.where(test_id: params[:test_id]).last
        unless student and course and test and result
            render json:{message:"Error in fetching in result of the student"},status: :not_found
        else
            render json:result, status: :ok
        end
    end

    def showtopictests
        student = Student.find(params[:student_id])
        course = @student.courses.find(params[:course_id])
        topic = @course.topics.find(params[:topic_id])
        tests = @topic.tests.all
        unless student and course and topic and tests
            render json:{message:"Error in getting student, course, topic, and tests details"},status: :not_found
        else
            render json:{"Student": student,"Course": course,"topic": topic,"tests": tests},status: :ok
        end
    end

    def taketopictests
        student = Student.find(params[:student_id])
        course = @student.courses.find(params[:course_id])
        topic = @course.topics.find(params[:topic_id])
        test = @topic.tests.find(params[:test_id])
        unless student and course and topic and test
            render json:{message:"Error in getting student, course, topic, and test details"},status: :not_found
        else
            render json:{"Student": student,"Course": course,"topic": topic,"test": test},status: :ok
        end
    end

    def validatetopictest
        student = Student.find(params[:student_id])
        course = @student.courses.find(params[:course_id])
        topic = @course.topics.find(params[:topic_id])
        test = @topic.tests.find(params[:test_id])
        answer_stu = params[:answer_stu]
        answer = params[:answer]
        mark = params[:mark]
        answer = Hash.new
        total_mark = 0
        mark_scored = 0
        test.questions.each do |key, value|
            answer[key] = value['answer']
            if value['answer'] == answer_stu[key]
                mark_scored = mark_scored + (value['mark'].to_i)
            end
            total_mark = total_mark+ (value['mark'].to_i)
        end
        test_history = TestHistory.new(mark_scored: mark_scored, total_mark: total_mark, answers: answer_stu, student: @student, test: @test)
        if student.test_histories << test_history
            render json:test_history,status: :created
        else
            render json:{message:"Error in recording test history"},status: :not_modified
        end
    end

    def topictestresult
        student = Student.find(params[:student_id])
        course = @student.courses.find(params[:course_id])
        topic = @course.topics.find(params[:topic_id])
        test = @topic.tests.find(params[:test_id])
        result = @student.test_histories.where(test_id: params[:test_id]).last
        unless student and course and test and result
            render json:{message:"Error in fetching in result of the student"},status: :not_found
        else
            render json:result, status: :ok
        end
    end
end
