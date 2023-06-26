class StudentsController < ApplicationController
  before_action :authenticate_user!  
  before_action :is_student?
  def show
    @user = current_user
    @student = Student.find_by(id:@user.userable_id)
  end

  private
  def is_student?
      unless user_signed_in? && current_user.userable_type == "Student"
          flash[:alert] = "Unauthorized action"
          redirect_to instructor_path(current_user.userable_id)
      end
      student = Student.find_by(id:params[:id])
      unless current_user.userable == student
        flash[:alert] = "You are not allowed to access another student"
        redirect_to student_path(current_user.userable)
      end  
  end
end
