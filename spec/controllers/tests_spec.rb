require 'rails_helper'
RSpec.describe TestsController,type: :controller do
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

    describe 'new course questions' do
        context "when user is not signed in" do
            before do
                get :newcoursequestions ,params:{course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :newcoursequestions ,params:{course_id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :newcoursequestions,params:{course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :newcoursequestions ,params:{course_id:0}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :newcoursequestions ,params:{course_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :newcoursequestions, params:{course_id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :newcoursequestions,params:{course_id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when the course is passed" do
            before do
                sign_in instructor_user
                get :newcoursequestions,params:{course_id:course.id}
            end
            it "renders new course questions template" do
                expect(response).to render_template(:newcoursequestions)
            end
        end
    end


    describe 'create course questions' do
        context "when user is not signed in" do
            before do
                post :createcoursequestions ,params:{course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                post :createcoursequestions ,params:{course_id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                post :createcoursequestions,params:{course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                post :createcoursequestions ,params:{course_id:0}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                post :createcoursequestions ,params:{course_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                post :createcoursequestions, params:{course_id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                post :createcoursequestions,params:{course_id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when the course is passed" do
            before do
                sign_in instructor_user
                post :createcoursequestions,params:{course_id:course.id,name:course_test.name,test:{question:{"0": "A==B?"},mark:{"0": "1"},answer:{"0": "2"},option:{"0":{"0": "Assign a to b","1": "check a to b","2": "none","3": "Invalid"}}}}
            end
            it "redirect to course tests path" do
                expect(response).to redirect_to(test_course_path(course))
            end
        end
    end

    describe 'show course tests' do
        context "when user is not signed in" do
            before do
                get :showcoursetests ,params:{course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :showcoursetests ,params:{course_id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :showcoursetests ,params:{course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :showcoursetests ,params:{course_id:0}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :showcoursetests ,params:{course_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :showcoursetests, params:{course_id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :showcoursetests,params:{course_id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when the course is passed" do
            before do
                sign_in instructor_user
                get :showcoursetests,params:{course_id:course.id}
            end
            it "renders show course tests template" do
                expect(response).to render_template(:showcoursetests)
            end
        end
    end



    describe 'show course questions' do
        context "when user is not signed in" do
            before do
                get :showcoursequestions ,params:{course_id:course.id,test_id:course_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :showcoursequestions ,params:{course_id:course.id,test_id:course_test.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :showcoursequestions,params:{course_id:course.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :showcoursequestions ,params:{course_id:0,test_id:course_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :showcoursequestions ,params:{course_id:0,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :showcoursequestions, params:{course_id:course_1.id,test_id:course_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :showcoursequestions,params:{course_id:course_1.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context 'when another test id is passed' do
            before do
                sign_in instructor_user
                get :showcoursequestions, params:{course_id:course.id,test_id:course_test_1.id}
            end
            it "redirects to test course path" do
                expect(response).to redirect_to(test_course_path(course))
            end
        end

        context 'when another test id is passed' do
            before do
                sign_in instructor_user
                get :showcoursequestions, params:{course_id:course.id,test_id:course_test_1.id}
            end
            it "show alert messages" do
                expect(flash[:alert]).to eq("You are not allowed to access another course test")
            end
        end

        context 'when test id is invalid' do
            before do
                sign_in instructor_user
                get :showcoursequestions, params:{course_id:course.id,test_id:0}
            end
            it "redirects to test course path" do
                expect(response).to redirect_to(test_course_path(course))
            end
        end

        context 'when test id is invalid' do
            before do
                sign_in instructor_user
                get :showcoursequestions, params:{course_id:course.id,test_id:0}
            end
            it "show alert messages" do
                expect(flash[:alert]).to eq("Test not found")
            end
        end

        context "when the test is passed" do
            before do
                sign_in instructor_user
                get :showcoursequestions,params:{course_id:course.id,test_id:course_test.id}
            end
            it "renders show course questions template" do
                expect(response).to render_template(:showcoursequestions)
            end
        end
    end

    describe 'update course questions' do
        context "when user is not signed in" do
            before do
                patch :updatecoursequestions ,params:{course_id:course.id,test_id:course_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                patch :updatecoursequestions ,params:{course_id:course.id,test_id:course_test.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                patch :updatecoursequestions,params:{course_id:course.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                patch :updatecoursequestions ,params:{course_id:0,test_id:course_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                patch :updatecoursequestions ,params:{course_id:0,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                patch :updatecoursequestions, params:{course_id:course_1.id,test_id:course_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                patch :updatecoursequestions,params:{course_id:course_1.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context 'when another test id is passed' do
            before do
                sign_in instructor_user
                patch :updatecoursequestions, params:{course_id:course.id,test_id:course_test_1.id}
            end
            it "redirects to test course path" do
                expect(response).to redirect_to(test_course_path(course))
            end
        end

        context 'when another test id is passed' do
            before do
                sign_in instructor_user
                patch :updatecoursequestions, params:{course_id:course.id,test_id:course_test_1.id}
            end
            it "show alert messages" do
                expect(flash[:alert]).to eq("You are not allowed to access another course test")
            end
        end

        context 'when test id is invalid' do
            before do
                sign_in instructor_user
                patch :updatecoursequestions, params:{course_id:course.id,test_id:0}
            end
            it "redirects to test course path" do
                expect(response).to redirect_to(test_course_path(course))
            end
        end

        context 'when test id is invalid' do
            before do
                sign_in instructor_user
                patch :updatecoursequestions, params:{course_id:course.id,test_id:0}
            end
            it "show alert messages" do
                expect(flash[:alert]).to eq("Test not found")
            end
        end

        context "when the test is passed" do
            before do
                sign_in instructor_user
                patch :updatecoursequestions,params:{course_id:course.id,test_id:course_test.id,name:course_test.name,question:{"0": "A==b?"},option:{"0":{"0": "a","1": "true","2": "false","3": "none"}},answer:{"0": "3"},mark:{"0": "1"}}
            end
            it "redirect to test course path" do
                expect(response).to redirect_to(test_course_path(course.id))
            end
        end
    end



    describe 'new topic questions' do
        context "when user is not signed in" do
            before do
                get :newtopicquestions ,params:{course_id:course.id,topic_id:topic.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :newtopicquestions ,params:{course_id:course.id,topic_id:topic.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :newtopicquestions ,params:{course_id:course.id,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :newtopicquestions ,params:{course_id:0,topic_id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :newtopicquestions ,params:{course_id:0,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :newtopicquestions, params:{course_id:course_1.id, topic_id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :newtopicquestions,params:{course_id:course_1.id, topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                get :newtopicquestions,params:{course_id:course.id,topic_id:topic_1.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                get :newtopicquestions,params:{course_id:course.id,topic_id:topic_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Cannot access another topic course")
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                get :newtopicquestions,params:{course_id:course.id,topic_id:0}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                get :newtopicquestions,params:{course_id:course.id,topic_id:0}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("Topic not found")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                get :newtopicquestions,params:{course_id:course.id,topic_id:topic.id}
            end
            it "renders new topic questions template" do
                expect(response).to render_template(:newtopicquestions)
            end
        end
    end

    describe 'create topic questions' do
        context "when user is not signed in" do
            before do
                post :createtopicquestions ,params:{course_id:course.id,topic_id:topic.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                post :createtopicquestions ,params:{course_id:course.id,topic_id:topic.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                post :createtopicquestions ,params:{course_id:course.id,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                post :createtopicquestions ,params:{course_id:0,topic_id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                post :createtopicquestions ,params:{course_id:0,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                post :createtopicquestions, params:{course_id:course_1.id, topic_id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                post :createtopicquestions,params:{course_id:course_1.id, topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                post :createtopicquestions,params:{course_id:course.id,topic_id:topic_1.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                post :createtopicquestions,params:{course_id:course.id,topic_id:topic_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Cannot access another topic course")
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                post :createtopicquestions,params:{course_id:course.id,topic_id:0}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                post :createtopicquestions,params:{course_id:course.id,topic_id:0}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("Topic not found")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                post :createtopicquestions,params:{course_id:course.id,topic_id:topic.id,name:topic_test.name,test:{question:{"0": "A==B?"},mark:{"0": "1"},answer:{"0": "2"},option:{"0":{"0": "Assign a to b","1": "check a to b","2": "none","3": "Invalid"}}}}
            end
            it "redirect to course topic path" do
                expect(response).to redirect_to(course_topic_path(course,topic))
            end
        end
    end
 

    describe 'show topic questions' do
        context "when user is not signed in" do
            before do
                get :showtopicquestions ,params:{course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :showtopicquestions ,params:{course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :showtopicquestions ,params:{course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :showtopicquestions ,params:{course_id:0,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :showtopicquestions ,params:{course_id:0,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :showtopicquestions, params:{course_id:course_1.id, topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :showtopicquestions,params:{course_id:course_1.id, topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                get :showtopicquestions,params:{course_id:course.id,topic_id:topic_1.id,test_id:topic_test.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                get :showtopicquestions,params:{course_id:course.id,topic_id:topic_1.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Cannot access another topic course")
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                get :showtopicquestions,params:{course_id:course.id,topic_id:0,test_id:topic_test.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                get :showtopicquestions,params:{course_id:course.id,topic_id:0,test_id:topic_test.id}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("Topic not found")
            end
        end

        context 'when another test id is passed' do
            before do
                sign_in instructor_user
                get :showtopicquestions, params:{course_id:course.id,topic_id:topic.id,test_id:topic_test_1.id}
            end
            it "redirects to test topic path" do
                expect(response).to redirect_to(test_topic_path(course,topic))
            end
        end

        context 'when another test id is passed' do
            before do
                sign_in instructor_user
                get :showtopicquestions, params:{course_id:course.id,topic_id:topic.id,test_id:topic_test_1.id}
            end
            it "show alert messages" do
                expect(flash[:alert]).to eq("Test is not in this topic")
            end
        end

        context 'when test id is invalid' do
            before do
                sign_in instructor_user
                get :showtopicquestions, params:{course_id:course.id,topic_id:topic.id,test_id:0}
            end
            it "redirects to test topic path" do
                expect(response).to redirect_to(test_topic_path(course,topic))
            end
        end

        context 'when test id is invalid' do
            before do
                sign_in instructor_user
                get :showtopicquestions, params:{course_id:course.id,topic_id:topic.id,test_id:0}
            end
            it "show alert messages" do
                expect(flash[:alert]).to eq("Test not found")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                get :showtopicquestions,params:{course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "renders show topic question template" do
                expect(response).to render_template(:showtopicquestions)
            end
        end
    end


    describe 'update topic questions' do
        context "when user is not signed in" do
            before do
                patch :updatetopicquestions ,params:{course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                patch :updatetopicquestions ,params:{course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                patch :updatetopicquestions ,params:{course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions ,params:{course_id:0,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions ,params:{course_id:0,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions, params:{course_id:course_1.id, topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions,params:{course_id:course_1.id, topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions,params:{course_id:course.id,topic_id:topic_1.id,test_id:topic_test.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions,params:{course_id:course.id,topic_id:topic_1.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Cannot access another topic course")
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions,params:{course_id:course.id,topic_id:0,test_id:topic_test.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions,params:{course_id:course.id,topic_id:0,test_id:topic_test.id}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("Topic not found")
            end
        end

        context 'when another test id is passed' do
            before do
                sign_in instructor_user
                patch :updatetopicquestions, params:{course_id:course.id,topic_id:topic.id,test_id:topic_test_1.id}
            end
            it "redirects to test topic path" do
                expect(response).to redirect_to(test_topic_path(course,topic))
            end
        end

        context 'when another test id is passed' do
            before do
                sign_in instructor_user
                patch :updatetopicquestions, params:{course_id:course.id,topic_id:topic.id,test_id:topic_test_1.id}
            end
            it "show alert messages" do
                expect(flash[:alert]).to eq("Test is not in this topic")
            end
        end

        context 'when test id is invalid' do
            before do
                sign_in instructor_user
                patch :updatetopicquestions, params:{course_id:course.id,topic_id:topic.id,test_id:0}
            end
            it "redirects to test topic path" do
                expect(response).to redirect_to(test_topic_path(course,topic))
            end
        end

        context 'when test id is invalid' do
            before do
                sign_in instructor_user
                patch :updatetopicquestions, params:{course_id:course.id,topic_id:topic.id,test_id:0}
            end
            it "show alert messages" do
                expect(flash[:alert]).to eq("Test not found")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                patch :updatetopicquestions,params:{course_id:course.id,topic_id:topic.id,test_id:topic_test.id,name:topic_test.name,question:{"0": "A==b?"},option:{"0":{"0": "a","1": "true","2": "false","3": "none"}},answer:{"0": "3"},mark:{"0": "1"}}
            end
            it "redirect to test topic path" do
                expect(response).to redirect_to(test_topic_path(course,topic))
            end
        end
    end
end