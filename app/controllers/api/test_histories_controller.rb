class Api::TestHistoriesController < Api::ApiController
    before_action :is_student?
    before_action :is_student_history?, except:[:studentHistory]
    def studentHistory
        student = Student.find_by(id:params[:student_id])
        test_histories = student.test_histories.all
        unless test_histories
            render json:{message:"No test histories for student #{student.user.name}"}, status: :no_content
        else
            render json:test_histories, status: :ok
        end
    end

    def showTestHistory
        student = Student.find_by(id:params[:student_id])
        test_history = student.test_histories.find_by(id:params[:test_history_id])
        test = test_history.test
        render json:test_history,status: :ok
    end

    private
    def is_student?
        unless user_signed_in? 
            render json:{message:"Unauthorized action"}, status: :unauthorized
        end
        student = Student.find_by(id:params[:student_id])
        if student
            unless current_user.userable == student && current_user.userable_type == "Student"
                render json:{message:"You have no access to another student"}, status: :forbidden
            end
        else
            render json:{message:"Student not found"}, status: :not_found
        end  
    end

    private
    def is_student_history?
        student = Student.find_by(id:params[:student_id])
        test_history = TestHistory.find_by(id:params[:test_history_id])
        if test_history
            unless student.test_histories.include?(test_history)
                render json:{message:"Test History not belongs to you"}, status: :forbidden
            end
        else
            render json:{message:"Test History not found"}, status: :not_found
        end
    end
end
