class StudentsController < ApplicationController
  def show
    @user = current_user
    @student = Student.find(@user.userable_id)
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    if @student.update(student_params)
        redirect_to @student
    else  
        render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to student_index_path, status: :see_other
  end

  private
  def student_params
    params.require(:student).permit(:name,:email,:gender,:department,:year)
  end
end
