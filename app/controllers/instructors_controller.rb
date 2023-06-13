class InstructorsController < ApplicationController
  def index
    @instructors = Instructor.all
  end
  def show
    @instructor = Instructor.find(params[:id])
  end
  def new
    @instructor = Instructor.new
  end
  def create
    @instructor = Instructor.new(instructor_params)
    if @instructor.save
      redirect_to @instructor
    else
        render :new, status: :unprocessable_entity
    end
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
    redirect_to "/instructor", status: :see_other
  end

  private
  def instructor_params
    params.require(:instructor).permit(:name,:email,:gender,:designation)
  end

end
