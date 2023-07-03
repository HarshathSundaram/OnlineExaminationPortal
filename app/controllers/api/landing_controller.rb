class Api::LandingController < Api::ApiController
  def index
    if current_user
      if current_user.userable_type == "Student"
        render json:{message: "Welcome to Online Examination Portal #{current_user.name} , #{current_user.userable_type}"},status: :ok
      elsif current_user.userable_type == "Instructor"
        render json:{message: "Welcome to Online Examination Portal #{current_user.name} , #{current_user.userable_type}"},status: :ok
      end
    else
      render json:{message: "Hello!! Welcome to Online Examination Portal Please Register Yourself to Access the Portal!!!!"}, status: :ok
    end  
  end
  
end
