require 'rails_helper'

RSpec.describe Api::LandingController, type: :request do
    let(:student) {create(:student)}
    let(:instructor) {create(:instructor)}

    let(:student_user) {create(:user, :for_student,userable: student)}
    let(:instructor_user) {create(:user, :for_instructor,userable: instructor)}

    let!(:student_user_token) { create(:doorkeeper_access_token , resource_owner_id: student_user.id)}
    let!(:instructor_user_token) { create(:doorkeeper_access_token , resource_owner_id: instructor_user.id)}

    describe "gets landing#index" do
        context "when user is not signed in" do
            before do
                get '/api'
            end
            it "returns status 401" do
                expect(response).to have_http_status(401)
            end
        end

        context "when student is signed in" do
            before do
                get '/api',params: {access_token: student_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
        end

        context "when instructor is signed_in" do
            before do
                get '/api',params: {access_token: instructor_user_token.token}
            end
            it "returns status 200" do 
                expect(response).to have_http_status(200)
            end
        end
    end

end