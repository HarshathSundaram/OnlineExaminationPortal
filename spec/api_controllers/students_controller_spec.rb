require 'rails_helper'

RSpec.describe Api::StudentsController, type: :request do
    let(:student) {create(:student)}
    let(:student_user) {create(:user, :for_student,userable: student)}

    let(:instructor) {create(:instructor)}
    let(:instructor_user) {create(:user, :for_instructor,userable: instructor)}

    let(:student_1){create(:student)}
    let(:student_user_1) {create(:user, :for_student, userable: student_1)}

    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:student_user_1_token) { create(:doorkeeper_access_token , resource_owner_id: student_user_1.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

    describe "student show" do
         context "when student is not signed in" do
            before do
                get '/api/students/:id',params: {id:student.id}
            end
            it "returns status 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when instructor is signed in" do
            before do
                get '/api/students/:id' ,params:{access_token:instructor_user_token.token,id:instructor.id}
            end
            it "return status 403" do
                expect(response).to have_http_status(403)       
            end
        end

        context "when student is signed in with invalid params" do
            before do
                get "/api/students/#{student_1.id}"  ,params:{access_token:student_user_token.token}
            end
            it "return status 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student is signed in with invalid params" do
            before do
                get "/api/students/#{0}" ,params:{access_token:student_user_token.token}
            end
            it "return status 404" do
                expect(response).to have_http_status(404)
            end
        end

        context "when student is signed in" do
            before do
                get "/api/students/#{student.id}" ,params:{access_token:student_user_token.token}
            end
            it "return status 200" do
                expect(response).to have_http_status(200)
            end
        end
    end
end