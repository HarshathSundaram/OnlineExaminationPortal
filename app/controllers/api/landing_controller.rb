class Api::LandingController < Api::ApiController
  # before_action :authenticate_user!
  def index
    # if current_user.userable_type == "Student"
    #   redirect_to student_path(current_user.userable_id)
    # elsif current_user.userable_type == "Instructor"
    #   redirect_to instructor_path(current_user.userable_id)

    render json:{message: "Welcome to Online Examination Portal"}
   end 
end
