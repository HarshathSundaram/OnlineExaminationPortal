class TestHistoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :is_student?
    before_action :is_history_available?, only:[:showTestHistory]
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
            redirect_to instructor_path(current_user.userable)
        end
        student = Student.find_by(id:params[:student_id])
        if student
            unless current_user.userable == student
                flash[:alert] = "You are not allowed to access another student"
                redirect_to student_path(current_user.userable)
            end 
        else
            flash[:alert] = "Student not found"
            redirect_to student_path(current_user.userable)
        end 
    end
    
    private
    def is_history_available?
        student = Student.find_by(id:params[:student_id])
        test_history = TestHistory.find_by(id:params[:test_history_id])
        if test_history
            unless student.test_histories.include?(test_history)
                flash[:alert] = "#{student.user.name} has no history with id #{params[:test_history_id]}"
                redirect_to student_history_path(student)
            end
        else
            flash[:alert] = "Test History not found"
            redirect_to student_history_path(student)
        end
    end
end
