require 'rails_helper'
RSpec.describe InstructorsController, type: :controller do

    let(:student) {create(:student)}
    let!(:student_user) { create(:user , :for_student , userable: student)}
    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }
    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    describe "get #show" do
        context "when instructor is not signed in" do
            before do
                get :show ,params:{id:instructor.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :show ,params:{id:student.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))        
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :show ,params:{id:student.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")        
            end
        end


        context "when instructor is signed in with invalid params" do
            before do
                sign_in instructor_user
                get :show,params:{id:instructor_1.id}
            end
            it "redirect to current instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when instructor is signed in with invalid params" do
            before do
                sign_in instructor_user
                get :show,params:{id:instructor_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor")
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :show,params:{id:instructor.id}
            end
            it "renders instructor show template" do
                expect(response).to render_template(:show)
            end
        end
    end
end