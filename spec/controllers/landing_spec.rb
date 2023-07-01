require 'rails_helper'

RSpec.describe LandingController, type: :controller do
    let(:student) {create(:student)}
    let(:instructor) {create(:instructor)}

    let(:student_user) {create(:user, :for_student,userable: student)}
    let(:instructor_user) {create(:user, :for_instructor,userable: instructor)}

    describe "gets landing#index" do
        context "when user is not signed in" do
            before do
               get :index 
            end
            it "redirect to sign in page" do
                expect(:response).to redirect_to(new_user_session_path)
            end
        end

        context "when student is signed in" do
            before do
                sign_in student_user
                get :index
            end
            it "redirects to student page" do
                expect(:response).to redirect_to(student_path(student))
            end
        end

        context "when instructor is signed_in" do
            before do
                sign_in instructor_user
                get :index
            end
            it "redirects to instructor page" do
                expect(:response).to redirect_to(instructor_path(instructor))
            end
        end
    end
end