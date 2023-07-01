require 'rails_helper'

RSpec.describe TestHistoriesController,type: :controller do
    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }

    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { create(:user , :for_instructor , userable: instructor_1) }

    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:student_1) {create(:student)}
    let(:student_user_1) { create(:user, :for_student, userable: student_1)}

    let(:course) {create(:course,instructor:instructor)}
    let(:course_test) {create(:test, :for_course, testable: course)}
    let(:test_history) {create(:test_history, test:course_test, student:student)}

    let(:course_1) {create(:course,instructor:instructor_1)}
    let(:course_test_1) { (create(:test, :for_course, testable: course_1))}
    let(:test_history_1) {create(:test_history, test:course_test_1,student: student_1)}

    describe "Student Test Histories" do
        context "when student is not signed in" do
            before do
                get :studentHistory ,params:{student_id:student.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :studentHistory ,params:{student_id:instructor.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :studentHistory ,params:{student_id:instructor.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :studentHistory,params:{student_id:student_1.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :studentHistory,params:{student_id:0}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :studentHistory,params:{student_id:student_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :studentHistory,params:{student_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Student not found")
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :studentHistory,params:{student_id:student.id}
            end
            it "renders student history template" do
                expect(response).to render_template(:studentHistory)
            end
        end
    end

    describe "Student Show Test History" do
        context "when student is not signed in" do
            before do
                get :showTestHistory ,params:{student_id:student.id,test_history_id:test_history.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showTestHistory ,params:{student_id:instructor.id,test_history_id:test_history.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))        
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :showTestHistory ,params:{student_id:instructor.id,test_history_id:test_history.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showTestHistory,params:{student_id:student_1.id,test_history_id:test_history.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showTestHistory,params:{student_id:0,test_history_id:test_history.id}
            end
            it "redirect to current student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showTestHistory,params:{student_id:student_1.id,test_history_id:test_history.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another student")
            end
        end

        context "when student is signed in with invalid params" do
            before do
                sign_in student_user
                get :showTestHistory,params:{student_id:0,test_history_id:test_history.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Student not found")
            end
        end

        context "when test history is pass with invalid params" do
            before do
                sign_in student_user
                get :showTestHistory,params:{student_id:student.id,test_history_id:test_history_1.id}
            end
            it "redirect to student test histories path" do
                expect(response).to redirect_to(student_history_path(student))
            end
        end

        context "when test history is pass with invalid params" do
            before do
                sign_in student_user
                get :showTestHistory,params:{student_id:student.id,test_history_id:0}
            end
            it "redirect to student test histories path" do
                expect(response).to redirect_to(student_history_path(student))
            end
        end

        context "when test history is pass with invalid params" do
            before do
                sign_in student_user
                get :showTestHistory,params:{student_id:student.id,test_history_id:test_history_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("#{student.user.name} has no history with id #{test_history_1.id}")
            end
        end

        context "when test history is pass with invalid params" do
            before do
                sign_in student_user
                get :showTestHistory,params:{student_id:student.id,test_history_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Test History not found")
            end
        end

    end

end