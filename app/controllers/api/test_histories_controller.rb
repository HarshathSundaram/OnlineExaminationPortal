class Api::TestHistoriesController < Api::ApiController
    # before_action :authenticate_user!
    # before_action :is_student?
    def studentHistory
        @student = Student.find_by(id:params[:student_id])
        @test_histories = @student.test_histories.all
    end

    def showTestHistory
        @student = Student.find_by(id:params[:student_id])
        @test_history = @student.test_histories.find_by(id:params[:test_history_id])
        @test = @test_history.test
    end

    private
    def is_student?
        unless user_signed_in? && current_user.userable_type == "Student"
            flash[:alert] = "Unauthorized action"
            redirect_to instructor_path(current_user.userable_id)
        end
        student = Student.find_by(id:params[:student_id])
        unless current_user.userable == student
            flash[:alert] = "You are not allowed to access another student"
            redirect_to student_path(current_user.userable)
        end  
    end
end
