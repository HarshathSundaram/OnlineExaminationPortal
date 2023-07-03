require 'rails_helper'

RSpec.describe Api::CoursesController, type: :request do
    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }


    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    let(:course) {create(:course,instructor:instructor)}
    let(:course_1) {create(:course,instructor:instructor_1)}

    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:instructor_user_1_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user_1.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

    describe "show" do
        context "when user is not signed in" do
            before do
                get "/api/instructors/#{instructor.id}/courses/#{course.id}"
            end
            it "return status code 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when student signed in" do
            before do
                get "/api/instructors/#{instructor.id}/courses/#{course.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when another instructor is passed in params" do
            before do
                get "/api/instructors/#{instructor_1.id}/courses/#{course.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end


        context "when invalid course params is passed" do
            before do
                get "/api/instructors/#{instructor.id}/courses/#{course_1.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when the course is passed" do
            before do
                get "/api/instructors/#{instructor.id}/courses/#{course.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end


    describe "create" do
        context "when instructor is signed in" do
            before do
                post "/api/instructors/#{instructor.id}/courses",params:{access_token:instructor_user_token.token,course:{name:course.name,category:course.category}}
            end
            it "return status code 201" do
                expect(response).to have_http_status(201)
            end
        end

    end


    describe "update" do
        context "when the course is passed" do
            before do
                patch "/api/instructors/#{instructor.id}/courses/#{course.id}",params:{access_token:instructor_user_token.token,course:{name:course.name,category:course.category}}
            end
            it "return status code 202" do
                expect(response).to have_http_status(202)
            end
        end
    end

    describe "delete" do
        context "when the course is passed" do
            before do
                delete "/api/instructors/#{instructor.id}/courses/#{course.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 303" do
                expect(response).to have_http_status(303)
            end
        end
    end
end