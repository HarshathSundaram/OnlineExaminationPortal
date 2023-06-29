class Api::StudentsTestsController < Api::ApiController
    before_action :is_student?
    before_action :is_student_course? 
    before_action :is_course_topic?, except: [:showcoursetests,:takecoursetests,:validatecoursetest, :coursetestresult]
    before_action :is_course_test?, except: [:showcoursetests,:showtopictests,:taketopictests,:validatetopictest,:topictestresult]
    before_action :is_topic_test?, except: [:showcoursetests, :showtopictests, :takecoursetests, :validatecoursetest, :coursetestresult]
    def showcoursetests
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        tests = course.tests.all
        unless tests
            render json:{message:"No tests available for the course #{course.name}"}, status: :not_found
        else
            render json:{"Student": student,"Course": course,"tests": tests},status: :ok
        end
    end

    def takecoursetests
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        test = course.tests.find_by(id:params[:test_id])
        render json:{"Student": student,"Course": course,"test": test},status: :ok
    end

    def validatecoursetest
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        test = course.tests.find_by(id:params[:test_id])  
        answer_stu = params[:answer_stu] 
        total_mark = 0
        mark_scored = 0
        test.questions.each.with_index do |value,index|
            if value['answer'] == answer_stu[index.to_s]
                mark_scored = mark_scored + (value['mark'].to_i)
            end
            total_mark = total_mark+ (value['mark'].to_i)
        end
        test_history = TestHistory.new(mark_scored: mark_scored, total_mark: total_mark, answers: answer_stu, student: student, test: test)
        if student.test_histories << test_history
            render json:test_history,status: :created
        else
            render json:{message:"Error in recording test history"},status: :not_modified
        end
    end

    def coursetestresult
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        test = course.tests.find_by(id:params[:test_id])
        result = student.test_histories.where(test_id: params[:test_id]).last
        unless result
            render json:{message:"Error in fetching in result of the student"},status: :not_found
        else
            render json:result, status: :ok
        end
    end

    def showtopictests
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        tests = topic.tests.all
        unless tests
            render json:{message:"No tests available for the topic #{topic.name}"}, status: :no_content
        else
            render json:{"Student": student,"Course": course,"tests": tests},status: :ok
        end
    end

    def taketopictests
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        test = topic.tests.find_by(id:params[:test_id])
        if test
            render json:{"Student": student,"Course": course,"topic": topic,"test": test},status: :ok
        else
            render json:{message:"Test Not Found"},status: :not_found
        end
    end

    def validatetopictest
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        test = topic.tests.find_by(id:params[:test_id])
        answer_stu = params[:answer_stu] 
        total_mark = 0
        mark_scored = 0
        test.questions.each.with_index do |value,index|
            if value['answer'] == answer_stu[index.to_s]
                mark_scored = mark_scored + (value['mark'].to_i)
            end
            total_mark = total_mark+ (value['mark'].to_i)
        end
        test_history = TestHistory.new(mark_scored: mark_scored, total_mark: total_mark, answers: answer_stu, student: student, test: test)
        if student.test_histories << test_history
            render json:test_history,status: :created
        else
            render json:{message:"Error in recording test history"},status: :not_modified
        end
    end

    def topictestresult
        student = Student.find_by(id:params[:student_id])
        course = student.courses.find_by(id:params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        test = topic.tests.find_by(id:params[:test_id])
        result = student.test_histories.where(test_id: params[:test_id]).last
        unless result
            render json:{message:"Error in fetching in result of the student"},status: :not_found
        else
            render json:result, status: :ok
        end
    end
    private
    def is_student?
        student = Student.find_by(id:params[:student_id])
        unless user_signed_in? 
            render json:{message:"Unauthorized action"}, status: :unauthorized
        end 
        if student 
            unless current_user.userable == student&& current_user.userable_type == "Student"
                render json:{message: "You have no access to this student"}, status: :forbidden
            end
        else
            render json:{message:"Student not found"},status: :not_found
        end
    end

    private
    def is_student_course?
        student = Student.find_by(id:params[:student_id])
        course = Course.find_by(id:params[:course_id])
        if course
            unless student.courses.include?(course)
                render json:{message:"You have not enrolled in this course"}, status: :forbidden
            end
        else
            render json:{messgae:"Course not found"}, status: :not_found
        end
    end

    private
    def is_course_topic?
        course = Course.find_by(id:params[:course_id])
        topic = Topic.find_by(id:params[:topic_id])
        if topic
            unless course.topics.include?(topic)
                render json:{message:"Topic is not found in this course"}, status: :forbidden
            end            
        else
            render json:{message:"Topic not found"}, status: :not_found
        end        
    end

    private
    def is_course_test?
        course = Course.find_by(id:params[:course_id])
        test = Test.find_by(id:params[:test_id])
        if test
            unless course.tests.include?(test)
                render json:{message:"Test is not in this course"},status: :forbidden
            end
        else
            render json:{message:"Test not found"}, status: :not_found
        end
    end

    private
    def is_topic_test?
        topic = Topic.find_by(id:params[:topic_id])
        test = Test.find_by(id:params[:test_id])
        if test
            unless topic.tests.include?(test)
                render json:{message:"Test is not in this topic"},status: :forbidden
            end
        else
            render json:{message:"Test not found"}, status: :not_found
        end
    end
   
end
