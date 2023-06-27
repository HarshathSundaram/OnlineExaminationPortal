class Api::TestHistoriesController < Api::ApiController
    before_action :is_student?
    def studentHistory
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Error in fetching student details"},status: :not_found
        else
            test_histories = student.test_histories.all
            unless test_histories
                render json:{message:"No test histories for student #{student.user.name}"}, status: :no_content
            else
                render json:test_histories, status: :ok
            end
        end
        
    end

    def showTestHistory
        student = Student.find_by(id:params[:student_id])
        unless student
            render json:{message:"Error in fetching student details"},status: :not_found
        else
            test_history = student.test_histories.find_by(id:params[:test_history_id])
            unless test_history
                render json:{message:"Error in fetching test history of the student"},status: :not_found
            else
                test = test_history.test
                render json:test_history,status: :ok
            end
        end
    end

    private
    def is_student?
        unless user_signed_in? && current_user.userable_type == "Student"
            render json:{message:"You have not permitted to access student"}, status: :forbidden
        end
        student = Student.find_by(id:params[:student_id])
        if student
            unless current_user.userable == student
                render json:{message:"You have no access to another student"}, status: :forbidden
            end
        else
            render json:{message:"Unauthorized student"}, status: :unauthorized
        end  
    end
end
