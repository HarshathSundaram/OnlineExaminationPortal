class Api::StudentsTestsController < Api::ApiController
    before_action :is_student?
    before_action :is_valid_course?
    def showcoursetests
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Error in getting student"},status: :not_found
        else
            course = student.courses.find_by(id:params[:course_id])
            unless course
                render json:{message:"No courses for the student #{student.user.name}"}, status: :not_found
            else
                tests = course.tests.all
                unless tests
                    render json:{message:"No tests available for the course #{course.name}"}, status: :not_found
                else
                    render json:{"Student": student,"Course": course,"tests": tests},status: :ok
                end
            end
            
        end
        
    end

    def takecoursetests
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Student is not found"},status: :internal_server_error
        else
            course = student.courses.find_by(id:params[:course_id])
            unless course
                render json:{message:"Course is not found"},status: :internal_server_error
            else
                test = course.tests.find_by(id:params[:test_id])
                unless test
                    render json:{message:"Error in getting student, course, and test details"},status: :not_found
                else
                    render json:{"Student": student,"Course": course,"test": test},status: :ok
                end
            end
        end
    end

    def validatecoursetest
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Student is not found"},status: :internal_server_error
        else
            course = student.courses.find_by(id:params[:course_id])
            unless course
                render json:{message:"Course is not found"},status: :internal_server_error
            else
                test = course.tests.find_by(id:params[:test_id])  
                unless test
                    render json:{message:"Test not found"},status: :internal_server_error
                else
                    answer_stu = params[:answer_stu] 
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
                    test_history = TestHistory.new(mark_scored: mark_scored, total_mark: total_mark, answers: answer_stu, student: student, test: test)
                    if student.test_histories << test_history
                        render json:test_history,status: :created
                    else
                        render json:{message:"Error in recording test history"},status: :not_modified
                    end
                end
            end
        end
    end

    def coursetestresult
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Student not found"},status: :internal_server_error
        else
            course = student.courses.find_by(id:params[:course_id])
            unless course
                render json:{message:"Course not found"},status: :internal_server_error
            else
                test = course.tests.find_by(id:params[:test_id])
                unless test
                    render json:{message:"Test not found"},status: :internal_server_error
                else
                    result = student.test_histories.where(test_id: params[:test_id]).last
                    unless result
                        render json:{message:"Error in fetching in result of the student"},status: :not_found
                    else
                        render json:result, status: :ok
                    end
                end
            end 
        end
    end

    def showtopictests
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Error in getting student"},status: :not_found
        else
            course = student.courses.find_by(id:params[:course_id])
            unless course
                render json:{message:"No courses for the student #{student.user.name}"}, status: :no_content
            else
                topic = course.topics.find_by(id:params[:topic_id])
                unless topic
                    render json:{message:"No topic for the course #{course.name}"}, status: :no_content
                else
                    tests = topic.tests.all
                    unless tests
                        render json:{message:"No tests available for the topic #{topic.name}"}, status: :no_content
                    else
                        render json:{"Student": student,"Course": course,"tests": tests},status: :ok
                    end
                end
            end
        end
    end

    def taketopictests
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Student not found"}, status: :internal_server_error
        else
            course = student.courses.find_by(id:params[:course_id])
            unless course
                render json:{message:"Course Not found"},status: :not_found
            else
                topic = course.topics.find_by(id:params[:topic_id])
                unless topic
                    render json:{message:"Topic Not Found "},status: :not_found
                else
                    test = topic.tests.find_by(id:params[:test_id])
                    if test
                        render json:{"Student": student,"Course": course,"topic": topic,"test": test},status: :ok
                    else
                        render json:{message:"Test Not Found"},status: :not_found
                    end
                end
            end 
        end
    end

    def validatetopictest
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Student not found"},status: :internal_server_error
        else
            course = student.courses.find_by(id:params[:course_id])
            unless course
                render json:{message:"Course not found"},status: :internal_server_error            
            else
                topic = course.topics.find_by(id:params[:topic_id])
                unless topic
                    render json:{message:"Topic not found"}, status: :internal_server_error
                else
                    test = topic.tests.find_by(id:params[:test_id])
                    unless test
                        render json:{message:"Test not found"}, status: :internal_server_error
                    else
                        answer_stu = params[:answer_stu] 
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
                        test_history = TestHistory.new(mark_scored: mark_scored, total_mark: total_mark, answers: answer_stu, student: student, test: test)
                        if student.test_histories << test_history
                            render json:test_history,status: :created
                        else
                            render json:{message:"Error in recording test history"},status: :not_modified
                        end
                    end
                end
            end
        end 
    end

    def topictestresult
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Student not found"},status: :internal_server_error
        else
            course = student.courses.find_by(id:params[:course_id])
            unless course
                render json:{message:"Course not found"},status: :internal_server_error
            else
                topic = course.topics.find_by(id:params[:topic_id])
                unless topic
                    render json:{message:"Topic not found"},status: :internal_server_error
                else
                    test = topic.tests.find_by(id:params[:test_id])
                    unless test
                        render json:{message:"Test not found"},status: :internal_server_error
                    else
                        result = student.test_histories.where(test_id: params[:test_id]).last
                        unless result
                            render json:{message:"Error in fetching in result of the student"},status: :not_found
                        else
                            render json:result, status: :ok
                        end
                    end
                end
            end
        end
    end
    private
    def is_student?
        student = Student.find_by(id:params[:student_id])
        unless user_signed_in? && current_user.userable_type == "Student"&& current_user.userable == student
            render json:{message:"You have no access to student"}, status: :forbidden
        end 
    end

    private
    def is_valid_course?
        student = Student.find_by(id:params[:student_id])
        course = Course.find_by(id:params[:course_id])
        unless student.courses.include?(course)
            render json:{message:"You are not enrolled in this course"}
        end
    end
end
