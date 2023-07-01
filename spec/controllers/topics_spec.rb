require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }


    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    let(:course) {create(:course,instructor:instructor)}
    let(:course_1) {create(:course,instructor:instructor_1)}

    let(:topic) {create(:topic, course:course)}
    let(:topic_1) {create(:topic, course:course_1)}

    describe "show" do
        context "when user is not signed in" do
            before do
                get :show ,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :show ,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :show ,params:{course_id:course.id,id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :show ,params:{course_id:0,id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :show ,params:{course_id:0,id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :show, params:{course_id:course_1.id, id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :show,params:{course_id:course_1.id, id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                get :show,params:{course_id:course.id,id:topic_1.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                get :show,params:{course_id:course.id,id:topic_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Topic not belongs to this course")
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                get :show,params:{course_id:course.id,id:0}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                get :show,params:{course_id:course.id,id:0}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("Topic not found")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                get :show,params:{course_id:course.id,id:topic.id}
            end
            it "renders show topic template" do
                expect(response).to render_template(:show)
            end
        end
    end

    
    describe "new" do
        context "when user is not signed in" do
            before do
                get :new ,params:{course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :new ,params:{course_id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :new ,params:{course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :new ,params:{course_id:0}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :new ,params:{course_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :new, params:{course_id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :new,params:{course_id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                get :new,params:{course_id:course.id}
            end
            it "renders new topic template" do
                expect(response).to render_template(:new)
            end
        end
    end


    describe "create" do
        context "when user is not signed in" do
            before do
                post :create ,params:{course_id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                post :create ,params:{course_id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                post :create ,params:{course_id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                post :create ,params:{course_id:0}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                post :create ,params:{course_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                post :create, params:{course_id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                post :create,params:{course_id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                post :create,params:{course_id:course.id,topic:{name:topic.name,description:topic.description}}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end
    end


    describe "edit" do
        context "when user is not signed in" do
            before do
                get :edit ,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :edit ,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :edit ,params:{course_id:course.id,id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :edit ,params:{course_id:0,id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                get :edit ,params:{course_id:0,id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :edit, params:{course_id:course_1.id, id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                get :edit,params:{course_id:course_1.id, id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                get :edit,params:{course_id:course.id,id:topic_1.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                get :edit,params:{course_id:course.id,id:topic_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Topic not belongs to this course")
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                get :edit,params:{course_id:course.id,id:0}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                get :edit,params:{course_id:course.id,id:0}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("Topic not found")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                get :edit,params:{course_id:course.id,id:topic.id}
            end
            it "renders edit topic template" do
                expect(response).to render_template(:edit)
            end
        end
    end

    describe "update" do
        context "when user is not signed in" do
            before do
                patch :update ,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                patch :update ,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                patch :update ,params:{course_id:course.id,id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                patch :update ,params:{course_id:0,id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                patch :update ,params:{course_id:0,id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                patch :update, params:{course_id:course_1.id, id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                patch :update,params:{course_id:course_1.id, id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                patch :update,params:{course_id:course.id,id:topic_1.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                patch :update,params:{course_id:course.id,id:topic_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Topic not belongs to this course")
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                patch :update,params:{course_id:course.id,id:0}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                patch :update,params:{course_id:course.id,id:0}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("Topic not found")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                patch :update,params:{course_id:course.id,id:topic.id,topic:{name:topic.name,description:topic.description}}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end
    end

    describe "delete" do
        context "when user is not signed in" do
            before do
                delete :destroy ,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                delete :destroy ,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                delete :destroy ,params:{course_id:course.id,id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                delete :destroy ,params:{course_id:0,id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course id passed" do
            before do
                sign_in instructor_user
                delete :destroy ,params:{course_id:0,id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Course not found")
            end
        end


        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                delete :destroy, params:{course_id:course_1.id, id:topic.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another course is passed in params" do
            before do
                sign_in instructor_user
                delete :destroy,params:{course_id:course_1.id, id:topic.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access another instructor course")
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                delete :destroy,params:{course_id:course.id,id:topic_1.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when invalid topic params is passed" do
            before do
                sign_in instructor_user
                delete :destroy,params:{course_id:course.id,id:topic_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Topic not belongs to this course")
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                delete :destroy,params:{course_id:course.id,id:0}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end

        context "when wrong topic params is passed" do
            before do
                sign_in instructor_user
                delete :destroy,params:{course_id:course.id,id:0}
            end
            it "shows alert message" do
                expect(flash[:alert]).to eq("Topic not found")
            end
        end

        context "when the topic is passed" do
            before do
                sign_in instructor_user
                delete :destroy,params:{course_id:course.id,id:topic.id}
            end
            it "redirect to instructor course page" do
                expect(response).to redirect_to(instructor_course_path(instructor,course))
            end
        end
    end
end