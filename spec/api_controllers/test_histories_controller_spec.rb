require 'rails_helper'

RSpec.describe Api::TestHistoriesController,type: :request do
    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }

    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { create(:user , :for_instructor , userable: instructor_1) }

    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:student_1) {create(:student)}
    let(:student_user_1) { create(:user, :for_student, userable: student_1)}

    let(:course) {create(:course,instructor:instructor)}
    let(:course_test) {create(:test, :for_course, testable: course)}
    let(:test_history) {create(:test_history, test:course_test, student:student)}

    let(:course_1) {create(:course,instructor:instructor_1)}
    let(:course_test_1) { (create(:test, :for_course, testable: course_1))}
    let(:test_history_1) {create(:test_history, test:course_test_1,student: student_1)}

    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:instructor_user_1_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user_1.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

     describe "Student Test Histories" do
        context "when student is not signed in" do
            before do
                get "/api/student/#{student.id}/test_history"
            end
            it "return status code 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when instructor is signed in" do
            before do
                get "/api/student/#{student.id}/test_history", params:{access_token: instructor_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)      
            end
        end


        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{student_1.id}/test_history", params:{access_token: student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{0}/test_history", params:{access_token: student_user_token.token}
            end
            it "returns status code 404" do
                expect(response).to have_http_status(404)
            end
        end


        context "when student is signed in" do
            before do
                get "/api/student/#{student.id}/test_history", params:{access_token: student_user_token.token}
            end
            it "returns status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe "Student Show Test History" do
      
        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{student_1.id}/test_history/#{test_history.id}",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{0}/test_history/#{test_history.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)
            end
        end


        context "when test history is pass with invalid params" do
            before do
                get "/api/student/#{student.id}/test_history/#{test_history_1.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student is signed in" do
            before do
                get "/api/student/#{student.id}/test_history/#{test_history.id}",params:{access_token:student_user_token.token}
            end
            it "returns status code 200" do
                expect(response).to have_http_status(200)
            end 
        end

    end

end