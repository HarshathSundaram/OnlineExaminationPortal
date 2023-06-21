class InstructorsController < ApplicationController
  before_action :authenticate_user!  
  before_action :is_instructor?
  def show
    @user = current_user
    @instructor = Instructor.find_by(id:@user.userable_id)
  end

  def edit
    @instructor = Instructor.find_by(id:params[:id])
  end

  def update
    @instructor = Instructor.find_by(id:params[:id])
    if @instructor.update(instructor_params)
        redirect_to @instructor
    else
        render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @instructor = Instructor.find_by(id:params[:id])
    @instructor.destroy
    redirect_to instructor_index_path, status: :see_other
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
