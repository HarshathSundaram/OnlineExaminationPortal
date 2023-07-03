require 'rails_helper'

RSpec.describe Api::TestsController,type: :request do
    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }


    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    let(:course) {create(:course,instructor:instructor)}
    let(:course_test) {create(:test, :for_course, testable: course)}

    let(:course_1) {create(:course,instructor:instructor_1)}
    let(:course_test_1) { (create(:test, :for_course, testable: course_1))}

    let(:topic) {create(:topic, course:course)}
    let(:topic_test) {create(:test, :for_topic, testable:topic)}

    let(:topic_1) {create(:topic, course:course_1)}
    let(:topic_test_1) {create(:test, :for_topic, testable: topic_1)}

    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:instructor_user_1_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user_1.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

    describe 'create course questions' do
        context "when user is not signed in" do
            before do
              post  "/api/course/#{course.id}/question"
            end
            it "returns status code 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when student signed in" do
            before do
                post  "/api/course/#{course.id}/question",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when invalid course id passed" do
            before do
                post  "/api/course/#{0}/question",params:{access_token:instructor_user_token.token}
            end
            it "returns status code 404" do
                expect(response).to have_http_status(404)
            end
        end

        context "when another course is passed in params" do
            before do
                post  "/api/course/#{course_1.id}/question",params:{access_token:instructor_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end

    end

    describe 'show course tests' do
        context "when student is signed in" do
            before do
                get "/api/course/#{course.id}/tests",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when the course is passed" do
            before do
                get "/api/course/#{course.id}/tests",params:{access_token:instructor_user_token.token}
            end
            it "returns status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end



    describe 'show course questions' do
        context "when student is signed in" do
            before do
                get "/api/course/#{course.id}/test/#{course_test.id}/question",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end
        context "when the test is passed" do
            before do
                get "/api/course/#{course.id}/test/#{course_test.id}/question",params:{access_token:instructor_user_token.token}
            end
            it "returns status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe 'update course questions' do
        context "when the student is signed in" do
            before do
                patch "/api/course/#{course.id}/test/#{course_test.id}/question",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end
        context "when the test is passed" do
            before do
                patch "/api/course/#{course.id}/test/#{course_test.id}/question",params:{access_token:instructor_user_token.token,name:course_test.name,question:{"0": "A==b?"},option:{"0":{"0": "a","1": "true","2": "false","3": "none"}},answer:{"0": "3"},mark:{"0": "1"}}
            end
            it "returns status code 202" do
                expect(response).to have_http_status(202)
            end
        end
    end

    describe 'show course tests' do
        context "when the student is signed in" do
            before do
                get "/api/course/#{course.id}/topic/#{topic.id}/tests",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end
        context "when the course is passed" do
            before do
                get "/api/course/#{course.id}/topic/#{topic.id}/tests",params:{access_token:instructor_user_token.token}
            end
            it "returns status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe 'show topic questions' do
        context "when the student is signed in" do
            before do
                get "/api/course/#{course.id}/topic/#{topic.id}/test/#{topic_test.id}/question",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end
        context "when the topic is passed" do
            before do
                get "/api/course/#{course.id}/topic/#{topic.id}/test/#{topic_test.id}/question",params:{access_token:instructor_user_token.token}
            end
            it "returns status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end


    describe 'update topic questions' do
        context "when the student is signed in" do
            before do
                patch "/api/course/#{course.id}/topic/#{topic.id}/test/#{topic_test.id}/question",params:{access_token:student_user_token.token,name:topic_test.name,question:{"0": "A==b?"},option:{"0":{"0": "a","1": "true","2": "false","3": "none"}},answer:{"0": "3"},mark:{"0": "1"}}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end
        context "when the topic is passed" do
            before do
                patch "/api/course/#{course.id}/topic/#{topic.id}/test/#{topic_test.id}/question",params:{access_token:instructor_user_token.token,name:topic_test.name,question:{"0": "A==b?"},option:{"0":{"0": "a","1": "true","2": "false","3": "none"}},answer:{"0": "3"},mark:{"0": "1"}}
            end
            it "returns status code 202" do
                expect(response).to have_http_status(202)
            end
        end
    end
end