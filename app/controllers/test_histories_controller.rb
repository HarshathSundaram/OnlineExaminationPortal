class TestHistoriesController < ApplicationController
    def studentHistory
        @student = Student.find(params[:student_id])
        @test_histories = @student.test_histories.all
    end

    def showTestHistory
        @student = Student.find(params[:student_id])
        @test_history = @student.test_histories.find(params[:test_history_id])
        @test = @test_history.test
    end
end
