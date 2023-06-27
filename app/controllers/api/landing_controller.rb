class Api::LandingController < Api::ApiController
  def index
    if current_user.userable_type == "Student"
      render json:{message: "Welcome to Online Examination Portal #{current_user.name} , #{current_user.userable_type}"}
    elsif current_user.userable_type == "Instructor"
      render json:{message: "Welcome to Online Examination Portal #{current_user.name} , #{current_user.userable_type}"}
    end
   end 
end
