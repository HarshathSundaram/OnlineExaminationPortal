require 'rails_helper'

RSpec.describe Api::StudentsTestsController,type: :request do
    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:student_1) { create(:student)}
    let(:student_user_1) { create(:user , :for_student , userable: student_1)}

    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }


    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    let(:course) {create(:course,instructor:instructor,students:[student])}
    let(:course_test) {create(:test, :for_course, testable: course)}

    let(:course_1) {create(:course,instructor:instructor_1)}
    let(:course_test_1) { (create(:test, :for_course, testable: course_1))}
    

    let(:topic) {create(:topic, course:course)}
    let(:topic_test) {create(:test, :for_topic, testable:topic)}

    let(:topic_1) {create(:topic, course:course_1)}
    let(:topic_test_1) {create(:test, :for_topic, testable: topic_1)}

    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:student_user_1_token) { create(:doorkeeper_access_token , resource_owner_id: student_user_1.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

    describe 'show course tests' do
        context "when student is not signed in" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/tests"
            end
            it "return status code 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when instructor is signed in" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/tests" ,params:{access_token:instructor_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end



        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{student_1.id}/course/#{course.id}/tests" ,params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student access unenrolled course" do
            before do
                get "/api/student/#{student.id}/course/#{course_1.id}/tests" ,params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student is signed in" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/tests" ,params:{access_token:student_user_token.token}
            end
            it "returns status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end


    describe 'take course tests' do

        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{student_1.id}/course/#{course.id}/tests/#{course_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student access unenrolled course" do
            before do
                get "/api/student/#{student.id}/course/#{course_1.id}/tests/#{course_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "whent student passes wrong test id" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/tests/#{course_test_1.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student is signed in" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/tests/#{course_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(200)
            end
        end
    end

    describe 'course test result' do

        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{student_1.id}/course/#{course.id}/test/#{course_test.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "when student access unenrolled course" do
            before do
                get "/api/student/#{student.id}/course/#{course_1.id}/test/#{course_test.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "whent student passes wrong test id" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/test/#{course_test_1.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "whent student passes invalid test id" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/test/#{0}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)
            end
        end

        context "when student is signed in" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/test/#{course_test.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(404)
            end
        end
    end

    describe 'validate course test' do

        context "when student is signed in with invalid params" do
            before do
                post "/api/student/#{student_1.id}/course/#{course.id}/test/#{course_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end


        context "when student access unenrolled course" do
            before do
                post "/api/student/#{student.id}/course/#{course_1.id}/test/#{course_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "whent student passes wrong test id" do
            before do
                post "/api/student/#{student.id}/course/#{course.id}/test/#{course_test_1.id}",params:{access_token:student_user_token.token}
            end
            it "returns status code 403" do
                expect(response).to have_http_status(403)
            end
        end

        context "whent student passes invalid test id" do
            before do
                post "/api/student/#{student.id}/course/#{course.id}/test/#{0}",params:{access_token:student_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)
            end
        end

        context "when student is signed in" do
            before do
                 post "/api/student/#{student.id}/course/#{course.id}/test/#{course_test.id}",params:{access_token:student_user_token.token,answer_stu:{"0": "check a is not equal to b"}}
            end
            it "return status code 201" do
                expect(response).to have_http_status(201)
            end
        end
    end



    describe 'show topic tests' do


        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{student_1.id}/course/#{course.id}/topic/#{topic.id}/tests",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end


        context "when student access unenrolled course" do
            before do
                get "/api/student/#{student.id}/course/#{course_1.id}/topic/#{topic.id}/tests",params:{access_token:student_user_token.token}
            end

            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "when student access invalid course topic" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic_1.id}/tests",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "when student is signed in" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/tests",params:{access_token:student_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(200)        
            end
        end
    end

    describe 'take topic test' do

        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{student_1.id}/course/#{course.id}/topic/#{topic.id}/tests/#{topic_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "when student access unenrolled course" do
            before do
                get "/api/student/#{student.id}/course/#{course_1.id}/topic/#{topic.id}/tests/#{topic_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "when student access invalid course topic" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic_1.id}/tests/#{topic_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "whent student passes wrong test id" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/tests/#{topic_test_1.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "whent student passes invalid test id" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/tests/#{0}",params:{access_token:student_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)        
            end
        end

        context "when student is signed in" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/tests/#{topic_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 200" do
                expect(response).to have_http_status(200)        
            end
        end
    end

    describe 'topic test result' do
       
        context "when student is signed in with invalid params" do
            before do
                get "/api/student/#{student_1.id}/course/#{course.id}/topic/#{topic.id}/test/#{topic_test.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "when student access unenrolled course" do
            before do
                get "/api/student/#{student.id}/course/#{course_1.id}/topic/#{topic.id}/test/#{topic_test.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "when student access invalid course topic" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic_1.id}/test/#{topic_test.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "whent student passes wrong test id" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/test/#{topic_test_1.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "whent student passes invalid test id" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/test/#{0}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)        
            end
        end

        context "when student is signed in" do
            before do
                get "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/test/#{topic_test.id}/result",params:{access_token:student_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)        
            end
        end 
    end

    describe "validate topic test" do

        context "when student is signed in with invalid params" do
            before do
                post "/api/student/#{student_1.id}/course/#{course.id}/topic/#{topic.id}/test/#{topic_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "when student access unenrolled course" do
            before do
                post "/api/student/#{student.id}/course/#{course_1.id}/topic/#{topic.id}/test/#{topic_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "when student access invalid course topic" do
            before do
                post "/api/student/#{student.id}/course/#{course.id}/topic/#{topic_1.id}/test/#{topic_test.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "whent student passes wrong test id" do
            before do
                post "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/test/#{topic_test_1.id}",params:{access_token:student_user_token.token}
            end
            it "return status code 403" do
                expect(response).to have_http_status(403)        
            end
        end

        context "whent student passes invalid test id" do
            before do
                post "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/test/#{0}",params:{access_token:student_user_token.token}
            end
            it "return status code 404" do
                expect(response).to have_http_status(404)        
            end
        end

        context "when student is signed in" do
            before do
                post "/api/student/#{student.id}/course/#{course.id}/topic/#{topic.id}/test/#{topic_test.id}",params:{access_token:student_user_token.token,answer_stu:{"0": "assign a to b"}}
            end
            it "return status code 201" do
                expect(response).to have_http_status(201)        
            end
        end  
    end
end
