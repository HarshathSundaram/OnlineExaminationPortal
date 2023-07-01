require 'rails_helper'

RSpec.describe StudentsTestsController, type: :controller do
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

    describe 'show course tests' do
        context "when student is not signed in" do
            before do
                get :showcoursetests ,params:{student_id:student.id,course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showcoursetests ,params:{student_id:instructor.id,course_id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showcoursetests ,params:{student_id:instructor.id,course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showcoursetests,params:{student_id:student_1.id,course_id:course.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showcoursetests,params:{student_id:student_1.id, course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                get :showcoursetests,params:{student_id:student.id,course_id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled in this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :showcoursetests,params:{student_id:student.id,course_id:course.id}
            end
            it "render show course tests template" do
                expect(response).to render_template(:showcoursetests)
            end
        end
    end


    describe 'take course tests' do
        context "when student is not signed in" do
            before do
                get :takecoursetests ,params:{student_id:student.id,course_id:course.id,test_id: course_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :takecoursetests ,params:{student_id:instructor.id,course_id:course.id,test_id: course_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :takecoursetests ,params:{student_id:instructor.id,course_id:course.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :takecoursetests,params:{student_id:student_1.id,course_id:course.id,test_id:course_test.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :takecoursetests,params:{student_id:student_1.id, course_id:course.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                get :takecoursetests,params:{student_id:student.id,course_id:course_1.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled in this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "whent student passes wrong test id" do
            before do
                sign_in student_user
                get :takecoursetests,params:{student_id:student.id,course_id:course.id,test_id:course_test_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("#{course.name} has not having this test #{course_test_1.name}")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_course_tests_path(student,course))
            end
        end

        context "whent student passes invalid test id" do
            before do
                sign_in student_user
                get :takecoursetests,params:{student_id:student.id,course_id:course.id,test_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Test not found")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_course_tests_path(student,course))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :takecoursetests,params:{student_id:student.id,course_id:course.id,test_id:course_test.id}
            end
            it "render take course tests template" do
                expect(response).to render_template(:takecoursetests)
            end
        end
    end

    describe 'course test result' do
        context "when student is not signed in" do
            before do
                get :coursetestresult ,params:{student_id:student.id,course_id:course.id,test_id: course_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :coursetestresult ,params:{student_id:instructor.id,course_id:course.id,test_id: course_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :coursetestresult ,params:{student_id:instructor.id,course_id:course.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :coursetestresult,params:{student_id:student_1.id,course_id:course.id,test_id:course_test.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :coursetestresult,params:{student_id:student_1.id, course_id:course.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                get :coursetestresult,params:{student_id:student.id,course_id:course_1.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled in this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "whent student passes wrong test id" do
            before do
                sign_in student_user
                get :coursetestresult,params:{student_id:student.id,course_id:course.id,test_id:course_test_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("#{course.name} has not having this test #{course_test_1.name}")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_course_tests_path(student,course))
            end
        end

        context "whent student passes invalid test id" do
            before do
                sign_in student_user
                get :coursetestresult,params:{student_id:student.id,course_id:course.id,test_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Test not found")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_course_tests_path(student,course))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :coursetestresult,params:{student_id:student.id,course_id:course.id,test_id:course_test.id}
            end
            it "render course test result template" do
                expect(response).to render_template(:coursetestresult)
            end
        end
    end

    describe 'validate course test' do
        context "when student is not signed in" do
            before do
                post :validatecoursetest ,params:{student_id:student.id,course_id:course.id,test_id: course_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                post :validatecoursetest ,params:{student_id:instructor.id,course_id:course.id,test_id: course_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                post :validatecoursetest ,params:{student_id:instructor.id,course_id:course.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                post :validatecoursetest,params:{student_id:student_1.id,course_id:course.id,test_id:course_test.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                post :validatecoursetest,params:{student_id:student_1.id, course_id:course.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                post :validatecoursetest,params:{student_id:student.id,course_id:course_1.id,test_id:course_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled in this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "whent student passes wrong test id" do
            before do
                sign_in student_user
                post :validatecoursetest,params:{student_id:student.id,course_id:course.id,test_id:course_test_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("#{course.name} has not having this test #{course_test_1.name}")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_course_tests_path(student,course))
            end
        end

        context "whent student passes invalid test id" do
            before do
                sign_in student_user
                post :validatecoursetest,params:{student_id:student.id,course_id:course.id,test_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Test not found")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_course_tests_path(student,course))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                post :validatecoursetest,params:{student_id:student.id,course_id:course.id,test_id:course_test.id,answer_stu:{"0": "check a is not equal to b"}}
            end
            it "redirect to student course result path" do
                expect(response).to redirect_to(student_course_result_path(student,course,course_test))
            end
        end
    end



    describe 'show topic tests' do
        context "when student is not signed in" do
            before do
                get :showtopictests ,params:{student_id:student.id,course_id:course.id,topic_id:topic.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showtopictests ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showtopictests ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showtopictests,params:{student_id:student_1.id,course_id:course.id,topic_id:topic.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showtopictests,params:{student_id:student_1.id, course_id:course.id,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                get :showtopictests,params:{student_id:student.id,course_id:course_1.id,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled in this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "when student access invalid course topic" do
            before do
                sign_in student_user
                get :showtopictests,params:{student_id:student.id,course_id:course.id,topic_id:topic_1.id}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("#{course.name} is not having this topic #{topic_1.name}")
            end
            it "redirect to student course path" do
                expect(response).to redirect_to(student_course_course_path(student,course))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :showtopictests,params:{student_id:student.id,course_id:course.id,topic_id:topic.id}
            end
            it "render show topic tests template" do
                expect(response).to render_template(:showtopictests)
            end
        end
    end

    describe 'take topic test' do
        context "when student is not signed in" do
            before do
                get :taketopictests ,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :taketopictests ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :taketopictests ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :taketopictests,params:{student_id:student_1.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :taketopictests,params:{student_id:student_1.id, course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                get :taketopictests,params:{student_id:student.id,course_id:course_1.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled in this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "when student access invalid course topic" do
            before do
                sign_in student_user
                get :taketopictests,params:{student_id:student.id,course_id:course.id,topic_id:topic_1.id,test_id:topic_test.id}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("#{course.name} is not having this topic #{topic_1.name}")
            end
            it "redirect to student course path" do
                expect(response).to redirect_to(student_course_course_path(student,course))
            end
        end

        context "whent student passes wrong test id" do
            before do
                sign_in student_user
                get :taketopictests,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("#{topic.name} has not having this test #{topic_test_1.name}")
            end
            it "redirect to student topic test path" do
                expect(response).to redirect_to(students_topic_tests_path(student,course,topic))
            end
        end

        context "whent student passes invalid test id" do
            before do
                sign_in student_user
                get :taketopictests,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Test not found")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_topic_tests_path(student,course,topic))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :taketopictests,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "render take topic tests template" do
                expect(response).to render_template(:taketopictests)
            end
        end
    end

    describe 'topic test result' do
       context "when student is not signed in" do
            before do
                get :topictestresult ,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :topictestresult ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :topictestresult ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :topictestresult,params:{student_id:student_1.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :topictestresult,params:{student_id:student_1.id, course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                get :topictestresult,params:{student_id:student.id,course_id:course_1.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled in this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "when student access invalid course topic" do
            before do
                sign_in student_user
                get :topictestresult,params:{student_id:student.id,course_id:course.id,topic_id:topic_1.id,test_id:topic_test.id}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("#{course.name} is not having this topic #{topic_1.name}")
            end
            it "redirect to student course path" do
                expect(response).to redirect_to(student_course_course_path(student,course))
            end
        end

        context "whent student passes wrong test id" do
            before do
                sign_in student_user
                get :topictestresult,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("#{topic.name} has not having this test #{topic_test_1.name}")
            end
            it "redirect to student topic test path" do
                expect(response).to redirect_to(students_topic_tests_path(student,course,topic))
            end
        end

        context "whent student passes invalid test id" do
            before do
                sign_in student_user
                get :topictestresult,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Test not found")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_topic_tests_path(student,course,topic))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :topictestresult,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "render topic test result template" do
                expect(response).to render_template(:topictestresult)
            end
        end 
    end

    describe "validate topic test" do
      context "when student is not signed in" do
            before do
                post :validatetopictest ,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                post :validatetopictest ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                post :validatetopictest ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                post :validatetopictest,params:{student_id:student_1.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                post :validatetopictest,params:{student_id:student_1.id, course_id:course.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                post :validatetopictest,params:{student_id:student.id,course_id:course_1.id,topic_id:topic.id,test_id:topic_test.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled in this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "when student access invalid course topic" do
            before do
                sign_in student_user
                post :validatetopictest,params:{student_id:student.id,course_id:course.id,topic_id:topic_1.id,test_id:topic_test.id}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("#{course.name} is not having this topic #{topic_1.name}")
            end
            it "redirect to student course path" do
                expect(response).to redirect_to(student_course_course_path(student,course))
            end
        end

        context "whent student passes wrong test id" do
            before do
                sign_in student_user
                post :validatetopictest,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("#{topic.name} has not having this test #{topic_test_1.name}")
            end
            it "redirect to student topic test path" do
                expect(response).to redirect_to(students_topic_tests_path(student,course,topic))
            end
        end

        context "whent student passes invalid test id" do
            before do
                sign_in student_user
                post :validatetopictest,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Test not found")
            end
            it "redirect to student course test path" do
                expect(response).to redirect_to(students_topic_tests_path(student,course,topic))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                post :validatetopictest,params:{student_id:student.id,course_id:course.id,topic_id:topic.id,test_id:topic_test.id,answer_stu:{"0": "assign a to b"}}
            end
            it "render topic test result template" do
                expect(response).to redirect_to(student_topic_result_path(student,course,topic,topic_test))
            end
        end  
    end

end