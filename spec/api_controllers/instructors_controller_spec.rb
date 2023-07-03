require 'rails_helper'

RSpec.describe Api::InstructorsController, type: :request do
    let(:student) {create(:student)}
    let(:student_user) {create(:user, :for_student,userable: student)}

    let(:instructor) {create(:instructor)}
    let(:instructor_user) {create(:user, :for_instructor,userable: instructor)}

    let(:instructor_1) {create(:instructor)}
    let(:instructor_user_1) {create(:user, :for_instructor,userable: instructor_1)}

    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:instructor_user_1_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user_1.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

    describe "get #show" do
        context "when instructor is not signed in" do
            before do
                get '/api/instructors/:id' ,params:{id:instructor.id}
            end
            it "return status 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when student is signed in" do
            before do
                get '/api/instructors/:id' ,params:{access_token:student_user_token.token,id:student.id}
            end
            it "return status 403" do
                expect(response).to have_http_status(403)        
            end
        end


        context "when instructor is signed in with invalid params" do
            before do
                get "/api/instructors/#{instructor_1.id}" ,params:{access_token:instructor_user_token.token}
            end
            it "return status 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when instructor is signed in with invalid params" do
            before do
                get "/api/instructors/#{0}" ,params:{access_token:instructor_user_token.token}
            end
            it "return status 404" do
                expect(response).to have_http_status(404)
            end
        end


        context "when instructor is signed in" do
            before do
                get "/api/instructors/#{instructor.id}" ,params:{access_token:instructor_user_token.token}
            end
            it "return status 200" do
                expect(response).to have_http_status(200)
            end
        end
    end
end