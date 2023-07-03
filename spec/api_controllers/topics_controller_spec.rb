require 'rails_helper'

RSpec.describe Api::TopicsController, type: :request do
    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }


    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    let(:course) {create(:course,instructor:instructor)}
    let(:course_1) {create(:course,instructor:instructor_1)}

    let(:topic) {create(:topic, course:course)}
    let(:topic_1) {create(:topic, course:course_1)}

    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:instructor_user_1_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user_1.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

    describe "show" do
        context "when user is not signed in" do
            before do
                get "/api/courses/#{course.id}/topics/#{topic.id}"
            end
            it "return status code 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when student signed in" do
            before do
                get "/api/courses/#{course.id}/topics/#{topic.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when invalid course id passed" do
            before do
                get "/api/courses/#{0}/topics/#{topic.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)
            end
        end

    
        context "when another course is passed in params" do
            before do
                get "/api/courses/#{course_1.id}/topics/#{topic.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end


        context "when invalid topic params is passed" do
            before do
                get "/api/courses/#{course.id}/topics/#{topic_1.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when wrong topic params is passed" do
            before do
                get "/api/courses/#{course.id}/topics/#{0}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)
            end
        end


        context "when the topic is passed" do
            before do
                get "/api/courses/#{course.id}/topics/#{topic.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end


    describe "create" do
        context "when the topic is passed" do
            before do
                post "/api/courses/#{course.id}/topics/",params:{access_token:instructor_user_token.token,topic:{name:topic.name,description:topic.description}}
            end
            it "return status code 201" do
                expect(response).to have_http_status(201)
            end
        end
    end


    describe "update" do
        context "when the topic is passed" do
            before do
                patch "/api/courses/#{course.id}/topics/#{topic.id}",params:{access_token:instructor_user_token.token,topic:{name:topic.name,description:topic.description}}
            end
            it "return status code 202" do
                expect(response).to have_http_status(202)
            end
        end
    end

    describe "delete" do
        context "when the topic is passed" do
            before do
                delete "/api/courses/#{course.id}/topics/#{topic.id}",params:{access_token:instructor_user_token.token}
            end
            it "return status code 303" do
                expect(response).to have_http_status(303)
            end
        end
    end
end