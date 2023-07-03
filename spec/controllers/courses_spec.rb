require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
    let(:student) { create(:student)}
    let(:student_user) { create(:user , :for_student , userable: student)}

    let(:instructor) { create(:instructor) }
    let(:instructor_user) { create(:user , :for_instructor , userable: instructor) }


    let(:instructor_1) { create(:instructor) }
    let(:instructor_user_1) { (create(:user , :for_instructor , userable: instructor_1))}

    let(:course) {create(:course,instructor:instructor)}
    let(:course_1) {create(:course,instructor:instructor_1)}

    describe "show" do
        context "when user is not signed in" do
            before do
                get :show ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :show ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :show ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                get :show ,params:{instructor_id:0,id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                get :show ,params:{instructor_id:0,id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Instructor not found")
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                get :show, params:{instructor_id:instructor_1.id, id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                get :show,params:{instructor_id:instructor_1.id, id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access other instructor")
            end
        end

        context "when invalid course params is passed" do
            before do
                sign_in instructor_user
                get :show,params:{instructor_id:instructor.id,id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course params is passed" do
            before do
                sign_in instructor_user
                get :show,params:{instructor_id:instructor.id,id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not the instructor of this course")
            end
        end

        context "when the course is passed" do
            before do
                sign_in instructor_user
                get :show,params:{instructor_id:instructor.id,id:course.id}
            end
            it "renders show course template" do
                expect(response).to render_template(:show)
            end
        end
    end

    describe "new" do
        context "when user is not signed in" do
            before do
                get :new ,params:{instructor_id:instructor.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :new,params:{instructor_id:instructor.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :new ,params:{instructor_id:instructor.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                get :new ,params:{instructor_id:0}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                get :new ,params:{instructor_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Instructor not found")
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                get :new, params:{instructor_id:instructor_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                get :new,params:{instructor_id:instructor_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access other instructor")
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                get :new,params:{instructor_id:instructor.id}
            end
            it "renders new course template" do
                expect(response).to render_template(:new)
            end
        end

    end

    describe "edit" do
        context "when user is not signed in" do
            before do
                get :edit ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :edit ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                get :edit ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                get :edit ,params:{instructor_id:0,id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                get :edit ,params:{instructor_id:0,id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Instructor not found")
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                get :edit, params:{instructor_id:instructor_1.id, id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                get :edit,params:{instructor_id:instructor_1.id, id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access other instructor")
            end
        end

        context "when invalid course params is passed" do
            before do
                sign_in instructor_user
                get :edit,params:{instructor_id:instructor.id,id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course params is passed" do
            before do
                sign_in instructor_user
                get :edit,params:{instructor_id:instructor.id,id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not the instructor of this course")
            end
        end

        context "when the course is passed" do
            before do
                sign_in instructor_user
                get :edit,params:{instructor_id:instructor.id,id:course.id}
            end
            it "renders edit course template" do
                expect(response).to render_template(:edit)
            end
        end
    end


    describe "create" do
        context "when user is not signed in" do
            before do
                post :create ,params:{instructor_id:instructor.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                post :create,params:{instructor_id:instructor.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                post :create ,params:{instructor_id:instructor.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                post :create ,params:{instructor_id:0}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                post :create ,params:{instructor_id:0}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Instructor not found")
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                post :create, params:{instructor_id:instructor_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                post :create,params:{instructor_id:instructor_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access other instructor")
            end
        end

        context "when instructor is signed in" do
            before do
                sign_in instructor_user
                post :create,params:{instructor_id:instructor.id,course:{name:course.name,category:course.category}}
            end
            it "renders new course template" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

    end


    describe "update" do
        context "when user is not signed in" do
            before do
                patch :update ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                patch :update ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                patch :update ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                patch :update ,params:{instructor_id:0,id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                patch :update ,params:{instructor_id:0,id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Instructor not found")
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                patch :update, params:{instructor_id:instructor_1.id, id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                patch :update,params:{instructor_id:instructor_1.id, id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access other instructor")
            end
        end

        context "when invalid course params is passed" do
            before do
                sign_in instructor_user
                patch :update,params:{instructor_id:instructor.id,id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course params is passed" do
            before do
                sign_in instructor_user
                patch :update,params:{instructor_id:instructor.id,id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not the instructor of this course")
            end
        end

        context "when the course is passed" do
            before do
                sign_in instructor_user
                patch :update,params:{instructor_id:instructor.id,id:course.id,course:{name:course.name,category:course.category}}
            end
            it "redirects to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor))
            end
        end
    end

    describe "delete" do
        context "when user is not signed in" do
            before do
                delete :destroy ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirect to sign in page" do
                expect(response).to redirect_to(new_user_session_path)
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                delete :destroy ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirect to student page" do
                expect(response).to redirect_to(student_path(student.id))
            end
        end

        context "when student signed in" do
            before do
                sign_in student_user
                delete :destroy ,params:{instructor_id:instructor.id,id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Unauthorized action")
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                delete :destroy ,params:{instructor_id:0,id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when instructor not or invalid passed" do
            before do
                sign_in instructor_user
                delete :destroy ,params:{instructor_id:0,id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("Instructor not found")
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                delete :destroy, params:{instructor_id:instructor_1.id, id:course.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when another instructor is passed in params" do
            before do
                sign_in instructor_user
                delete :destroy,params:{instructor_id:instructor_1.id, id:course.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not allowed to access other instructor")
            end
        end

        context "when invalid course params is passed" do
            before do
                sign_in instructor_user
                delete :destroy,params:{instructor_id:instructor.id,id:course_1.id}
            end
            it "redirect to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor.id))
            end
        end

        context "when invalid course params is passed" do
            before do
                sign_in instructor_user
                delete :destroy,params:{instructor_id:instructor.id,id:course_1.id}
            end
            it "show alert message" do
                expect(flash[:alert]).to eq("You are not the instructor of this course")
            end
        end

        context "when the course is passed" do
            before do
                sign_in instructor_user
                delete :destroy,params:{instructor_id:instructor.id,id:course.id}
            end
            it "redirects to instructor page" do
                expect(response).to redirect_to(instructor_path(instructor))
            end
        end
    end

end