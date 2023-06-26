class InstructorsController < ApplicationController
  before_action :authenticate_user!  
  before_action :is_instructor?
  def show
    @user = current_user
    @instructor = Instructor.find_by(id:@user.userable_id)
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
