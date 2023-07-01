require 'rails_helper'

RSpec.describe StudentsCoursesController, type: :controller do
    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:student_1) { create(:student)}
    let(:student_user_1) { create(:user , :for_student , userable: student_1)}

    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }


    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    let(:course) {create(:course,instructor:instructor,students:[student])}
    let(:course_1) {create(:course,instructor:instructor_1)}


    let(:topic) {create(:topic, course:course)}
    let(:topic_1) {create(:topic, course:course_1)}


    describe "index" do
        context "when student is not signed in" do
            before do
                get :index ,params:{student_id:student.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :index ,params:{student_id:instructor.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :index ,params:{student_id:instructor.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :index,params:{student_id:student_1.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :index,params:{student_id:student_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :index,params:{student_id:student.id}
            end
            it "renders instructor show template" do
                expect(response).to render_template(:index)
            end
        end
    end
    
    describe "enroll" do
        context "when student is not signed in" do
            before do
                get :enroll ,params:{student_id:student.id,course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :enroll ,params:{student_id:instructor.id,course_id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :enroll ,params:{student_id:instructor.id,course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :enroll,params:{student_id:student_1.id,course_id:course.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :enroll,params:{student_id:student_1.id, course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student enrolled already enrolled course" do
            before do
                sign_in student_user
                get :enroll,params:{student_id:student.id, course_id:course.id}
            end
            it "redirect to student path" do
                expect(response).to redirect_to(student_path(student))
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have already enrolled in this course")
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :enroll,params:{student_id:student.id,course_id:course_1.id}
            end
            it "redirect to student path" do
                expect(response).to redirect_to(student_path(student))
            end
            it "show successfull enrolled message" do
                expect(flash[:notice]).to eq("Successfully enrolled")
            end
        end
    end

    describe 'unenroll' do
        context "when student is not signed in" do
            before do
                get :unenroll ,params:{student_id:student.id,course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :unenroll ,params:{student_id:instructor.id,course_id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :unenroll ,params:{student_id:instructor.id,course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :unenroll,params:{student_id:student_1.id,course_id:course.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :unenroll,params:{student_id:student_1.id, course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student try to unenroll the unenrolled courses" do
            before do
                sign_in student_user
                get :unenroll, params:{student_id:student.id,course_id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled into this course")
            end
            it "redirect to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end
    end

    describe 'showcourse' do
        context "when student is not signed in" do
            before do
                get :showcourse ,params:{student_id:student.id,course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showcourse ,params:{student_id:instructor.id,course_id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showcourse ,params:{student_id:instructor.id,course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showcourse,params:{student_id:student_1.id,course_id:course.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showcourse,params:{student_id:student_1.id, course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                get :showcourse,params:{student_id:student.id,course_id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled into this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :showcourse,params:{student_id:student.id,course_id:course.id}
            end
            it "render show course template" do
                expect(response).to render_template(:showcourse)
            end
        end
    end

    describe 'showtopic' do
         context "when student is not signed in" do
            before do
                get :showtopic ,params:{student_id:student.id,course_id:course.id,topic_id:topic.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showtopic ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showtopic ,params:{student_id:instructor.id,course_id:course.id,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showtopic,params:{student_id:student_1.id,course_id:course.id,topic_id:topic.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showtopic,params:{student_id:student_1.id, course_id:course.id,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student access unenrolled course" do
            before do
                sign_in student_user
                get :showtopic,params:{student_id:student.id,course_id:course_1.id,topic_id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You have not enrolled into this course")
            end
            it "redirect_to student path" do
                expect(response).to redirect_to(student_path(student))
            end
        end

        context "when student access invalid course topic" do
            before do
                sign_in student_user
                get :showtopic,params:{student_id:student.id,course_id:course.id,topic_id:topic_1.id}
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
                get :showtopic,params:{student_id:student.id,course_id:course.id,topic_id:topic.id}
            end
            it "render show topic template" do
                expect(response).to render_template(:showtopic)
            end
        end
    end
end