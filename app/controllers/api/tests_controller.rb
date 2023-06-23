class Api::TestsController < Api::ApiController
    #before_action :authenticate_user!  
    #Course
    def newcoursequestions
        course = Course.find_by(id:params[:course_id])        
    end
    def createcoursequestions
        course = Course.find_by(id:params[:course_id])
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
        t = Test.new(name: name, questions: test)
        if course.tests << t
            render json:t, status: :created
        else
            render json:{message:"Error in creating test for course #{course.name}"},status: :unprocessable_entity
    end
    def showcoursequestions
        course = Course.find_by(id:params[:course_id])
        test = course.tests.find_by(id:params[:test_id])
        unless course and test
            render json:{message:"Error in fetching test details"}, status: :not_found
        else
            render json:test, status: :ok
        end
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
                        render json:{message:"Something went wrong while updating history"},status: :not_modified
                    end
                  end
                end
              end
            render json:test,status: :accepted  
        else
            render json:{message:"Something went wrong in updating test"},status: :not_modified
        end
    end

    def showcoursetests
        course = Course.find_by(id:params[:course_id])
        tests = course.tests.all
        unless course
            render json:{message:"Error while fetching course"},status: :not_found
        end
        unless tests
            render json:{message:"No tests available for the course #{course.name}"},status: :no_content
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
        unless course
            render json:{message:"Error while fetching course"},status: :not_found
        end
        unless topic
            render json:{message:"Error while fetching topic"},status: :not_found
        end
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
end
