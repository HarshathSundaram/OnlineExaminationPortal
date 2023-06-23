class Api::InstructorsController < Api::ApiController
  # before_action :authenticate_user!  
  # before_action :is_instructor?
  def show
    # @user = current_user
    # @instructor = Instructor.find_by(id:@user.userable_id)

    instructor = Instructor.find_by(id: params[:id])
    name = instructor.user.name
    if instructor
        render json:{"name": name,"Instructor": instructor}, status: :ok
    else
        render json:{message: "Instructor not found"}, status: :not_found
    end
  end

  def edit
    instructor = Instructor.find_by(id:params[:id])
  end

  def update
    instructor = Instructor.find_by(id:params[:id])
    if instructor.update(instructor_params)
        render json:instructor, status: :accepted
    else
        render json:{message:"Error in updating Instructor"}, status: :not_modified
    end
  end

  def destroy
    instructor = Instructor.find_by(id:params[:id])
    if instructor.destroy
      render json:{message:"Instructor deleted successfully"}, status: :see_other
    else
      render json:{message: "Error in deleting instructor"}, status: :not_modified
  end

  private
  def instructor_params
    params.require(:instructor).permit(:name,:email,:gender,:designation)
  end

  private
  def is_instructor?
      unless user_signed_in? && current_user.userable_type == "Instructor"
          flash[:alert] = "Unauthorized action"
          redirect_to student_path(current_user.userable_id)
      end
      instructor = Instructor.find_by(id:params[:id])
      unless current_user.userable == instructor
        flash[:alert] = "You are not allowed to access another instructor"
        redirect_to instructor_path(current_user.userable)
      end  
  end

end
