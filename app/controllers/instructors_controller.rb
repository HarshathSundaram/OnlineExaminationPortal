class InstructorsController < ApplicationController
  def show
    @user = current_user
    @instructor = Instructor.find(@user.userable_id)
  end

  def edit
    @instructor = Instructor.find(params[:id])
  end

  def update
    @instructor = Instructor.find(params[:id])
    if @instructor.update(instructor_params)
        redirect_to @instructor
    else
        render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @instructor = Instructor.find(params[:id])
    @instructor.destroy
    redirect_to instructor_index_path, status: :see_other
  end

  private
  def instructor_params
    params.require(:instructor).permit(:name,:email,:gender,:designation)
  end

end
