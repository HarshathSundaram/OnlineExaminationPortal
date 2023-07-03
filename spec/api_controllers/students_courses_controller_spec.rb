require 'rails_helper'

RSpec.describe Api::StudentsCoursesController,type: :request do
    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:student_1) { create(:student)}
    let(:student_user_1) { create(:user , :for_student , userable: student_1)}

    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }
    
    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:student_user_1_token) { create(:doorkeeper_access_token , resource_owner_id: student_user_1.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    let(:course) {create(:course,instructor:instructor,students:[student])}
    let(:course_1) {create(:course,instructor:instructor_1)}


    let(:topic) {create(:topic, course:course)}
    let(:topic_1) {create(:topic, course:course_1)}

    describe "index" do
        context "when student is not signed in" do
            before do
              get  "/api/students/#{student.id}/allcourses"
            end
            it "return status code 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when instructor is signed in" do
            before do
                get "/api/students/#{student.id}/allcourses" ,params:{access_token:instructor_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                get  "/api/students/#{student_1.id}/allcourses",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end


        context "when student is signed in" do
            before do
                get "/api/students/#{student.id}/allcourses",params:{access_token:student_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end
    
    describe "enroll" do

        context "when student is signed in with invalid params" do
            before do
                get "/api/students/#{student_1.id}/course/#{course.id}/enroll", params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student enrolled already enrolled course" do
            before do
                get "/api/students/#{student.id}/course/#{course.id}/enroll", params:{access_token:student_user_token.token}
            end
            it "returns status code 400" do
                expect(response).to have_http_status(400)
            end
        end

        context "when student is signed in" do
            before do
                get "/api/students/#{student.id}/course/#{course_1.id}/enroll", params:{access_token:student_user_token.token}
            end
            it "returns status code 201" do
                expect(response).to have_http_status(201)
            end
        end
    end

    describe 'unenroll' do

        context "when student is signed in with invalid params" do
            before do
                get "/api/students/#{student_1.id}/course/#{course.id}/unenroll",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student try to unenroll the unenrolled courses" do
            before do
                get "/api/students/#{student.id}/course/#{course_1.id}/unenroll",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student successfully unenrolled in a course" do
            before do
                get "/api/students/#{student.id}/course/#{course.id}/unenroll",params:{access_token:student_user_token.token}
            end
            it "return status code 202" do
                expect(response).to have_http_status(202)
            end
        end
    end

    describe 'showcourse' do
        
        context "when student is signed in with invalid params" do
            before do
                get "/api/students/#{student_1.id}/course/#{course.id}/showcourse",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student access unenrolled course" do
            before do
                get "/api/students/#{student.id}/course/#{course_1.id}/showcourse",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student is signed in" do
            before do
                get "/api/students/#{student.id}/course/#{course.id}/showcourse",params:{access_token:student_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe 'showtopic' do


        context "when student is signed in with invalid params" do
            before do
                get "/api/students/#{student_1.id}/course/#{course.id}/topic/#{topic.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student access unenrolled course" do
            before do
                get "/api/students/#{student.id}/course/#{course_1.id}/topic/#{topic.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student access invalid course topic" do
            before do
                get "/api/students/#{student.id}/course/#{course.id}/topic/#{topic_1.id}",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student is signed in" do
            before do
                get "/api/students/#{student.id}/course/#{course.id}/topic/#{topic.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end
end