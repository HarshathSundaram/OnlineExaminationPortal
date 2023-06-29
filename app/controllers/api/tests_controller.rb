class Api::TestsController < Api::ApiController
    before_action :is_instructor?
    before_action :is_instrctor_course? , except: [:testsAttended]
    before_action :is_course_topic?, except: [:testsAttended, :newcoursequestions,:createcoursequestions,:showcoursequestions,:updatecoursequestions,:showcoursetests,:destroycoursetests]
    before_action :is_course_test? , except: [:testsAttended,:newcoursequestions,:createcoursequestions,:showcoursetests,:newtopicquestions,:createtopicquestions,:showtopicquestions,:updatetopicquestions,:showtopictests,:destroytopictests]
    before_action :is_topic_test? , except: [:testsAttended,:newtopicquestions,:createtopicquestions,:showtopictests,:newcoursequestions,:createcoursequestions,:showcoursequestions,:updatecoursequestions,:showcoursetests,:destroycoursetests]
    #Course
    def newcoursequestions
        course = Course.find_by(id:params[:course_id])        
    end
    def createcoursequestions
        course = Course.find_by(id:params[:course_id])
        name = params[:name]
        question = params[:test][:question]
        options = params[:test][:option]
        answer = params[:test][:answer]
        mark = params[:test][:mark]
        a = question.keys
        test = []
        a.each do |key|
            ans = Integer(answer[key])
            ans = ans-1
            test << {
                "question" => question[key],
                "options" => options[key],
                "answer" => options[key][ans.to_s],
                "mark" => mark[key]
            }
        end
        t = Test.new(name: name, questions: test)
        if course.tests << t
            render json:t, status: :created
        else
            render json:{message:"Error in creating test for course #{course.name}"},status: :unprocessable_entity
        end
    end
    def showcoursequestions
        course = Course.find_by(id:params[:course_id])
        test = course.tests.find_by(id:params[:test_id])
        render json:test, status: :ok    
    end
    def updatecoursequestions
        course = Course.find_by(id:params[:course_id])
        test = course.tests.find_by(id:params[:test_id])
        name = params[:name]
        question = params[:question]
        options = params[:option]
        answer = params[:answer]
        mark = params[:mark]
        a = question.keys
        ques = []
        a.each do |key|
            ans = Integer(answer[key])
            ans = ans-1
            puts ans
            puts "Option Answer"
            puts options[key][ans.to_s]
            ques << {
                "question" => question[key],
                "options" => options[key],
                "answer" => options[key][ans.to_s],
                "mark" => mark[key]
            }
        end
        puts(ques)
        if test.update({name:name,questions:ques})
            if !test.test_histories.blank?
                test_histories = test.test_histories.all
                test_histories.each do |history|
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
            render json:test, status: :accepted
        else
            render json:{message:"Test is updated"}, status: :not_modified
        end
    end

    def showcoursetests
        course = Course.find_by(id:params[:course_id])
        tests = course.tests.all
        unless tests
            render json:{message:"No tests available for the topic #{course.name}"},status: :no_content
        else
            render json:tests,status: :ok
        end
    end
   
   
    def destroycoursetests
        course = Course.find_by(id:params[:course_id])
        test = course.tests.find_by(id:params[:test_id])
        if test.destroy
            render json:{message:"Test destroyed successfully"},status: :see_other
        else
            render json:{message:"Something went wrong while detroying test"},status: :not_modified
        end
    end


    #Topic
    def newtopicquestions
        course = Course.find_by(id: params[:course_id])
        topic = course.topics.find_by(id: params[:topic_id])
    end
    def createtopicquestions
        course = Course.find_by(id: params[:course_id])
        topic = course.topics.find_by(id: params[:topic_id])
        name = params[:name]
        question = params[:question]
        options = params[:option]
        answer = params[:answer]
        mark = params[:mark]
        a = question.keys
        test = []
        a.each do |key|
            ans = Integer(answer[key])
            ans = ans-1
            test << {
                "question" => question[key],
                "options" => options[key],
                "answer" => options[key][ans.to_s],
                "mark" => mark[key]
            }
        end
        t = Test.new(name: name, questions: test)
        if topic.tests << t
            render json:t,status: :ok
        else
            render json:{message:"Error while creating test"},status: :unprocessable_entity
        end
    end

    def showtopicquestions
        course = Course.find_by(id: params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        test = Test.find_by(id:params[:test_id])
        render json:test, status: :ok
    end
    def updatetopicquestions
        course = Course.find_by(id: params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        test = topic.tests.find_by(id:params[:test_id])
        name = params[:name]
        question = params[:question]
        options = params[:option]
        answer = params[:answer]
        mark = params[:mark]
        a = question.keys
        ques = []
        a.each do |key|
            ans = Integer(answer[key])
            ans = ans-1
            puts ans
            puts "Option Answer"
            puts options[key][ans.to_s]
            ques << {
                "question" => question[key],
                "options" => options[key],
                "answer" => options[key][ans.to_s],
                "mark" => mark[key]
            }
        end
        new_t = Test.new(name: name, questions: ques)
        if test.update({name:name,questions:ques})
            if !test.test_histories.blank?
                test_histories = test.test_histories.all
                test_histories.each do |history|
                    total_mark = 0
                    mark_scored = 0
                    answer_stu = history.answers
                    ques.each do |key, value|
                        total_mark = total_mark + (value['mark'].to_i)
                        if value['answer'] == answer_stu[key]
                            mark_scored = mark_scored + (value['mark'].to_i)
                        end
                        unless history.update({ mark_scored: mark_scored, total_mark: total_mark })
                            render json:{message:"Something went wrong while updating history of test"},status: :not_modified
                        end
                    end
                end
            end
            render json:test, status: :accepted
        else
            render json:{message:"Something went wrong while updating test"}, status: :not_modified
        end
    end

    def showtopictests
        course = Course.find_by(id: params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        tests = topic.tests.all
        unless tests
            render json:{message:"No tests available for the topic #{topic.name}"},status: :no_content
        else
            render json:tests,status: :ok
        end
    end
    def destroytopictests
        course = Course.find_by(id: params[:course_id])
        topic = course.topics.find_by(id:params[:topic_id])
        test = topic.tests.find_by(id:params[:test_id])
        if test.destroy
            render json:{message:"Test destroyed successfully"},status: :see_other
        else
            render json:{message:"Something went wrong while detroying test"},status: :not_modified
        end
    end



    def testsAttended
        test_name = []
        tests = Test.all
        count = params[:count].to_i
        tests.each do |test|
            if test.test_histories.count == count
                test_name << {"Test Name": test.name, "Test Type": test.testable_type, "#{test.testable_type} Name": test.testable.name}
            end
        end   
        if test_name.blank?
            render json:{message:"There is no tests which taken #{count} times"},status: :internal_server_error
        else
            render json:test_name,status: :ok
        end     
    end


    private
    def is_instructor?
        unless user_signed_in?
            render json:{messgae:'Unauthorized Action'}, status: :unauthorized
        end

        unless current_user.userable_type == "Instructor"
            render json:{message:"You are not allowed to access instructor"}, status: :forbidden
        end
    end

    private
    def is_instrctor_course?
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
        topic = Topic.find_by(id:params[:topic_id])
        if topic
            unless course.topics.include?(topic)
                render json:{message:"Topic is not in the course"}, status: :forbidden
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
                render json:{message:"Test is not found in the course"}, status: :forbidden 
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
                render json:{message:"Test is not found in the course"}, status: :forbidden  
            end          
        else
            render json:{message:"Test not found"}, status: :not_found
        end      
    end
end


