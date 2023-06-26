class Api::StudentsController < Api::ApiController
  # before_action :authenticate_user!  
  # before_action :is_student?
  def show
    # @user = current_user
    # @student = Student.find_by(id:@user.userable_id)
    student = Student.find_by(id:params[:id])
    if student
      name = student.user.name
      render json:{"name": name,"Student": student}, status: :ok
    else
        render json:{message: "Student not found"}, status: :internal_server_error
    end
    
  end

  def studentsOfDepartment
    student_name=[]
    students = Student.all
    department = params[:department]
    students.each do |student|
      if student.department == department
        student_name<<student.user.name
      end      
    end
    if student_name.blank?
      render json:{message:"There is no student in #{department} department"},status: :internal_server_error
    else
      render json:student_name,status: :ok
    end
  end

  def studentEnrolledCourses
    student_name  = []
    students = Student.all
    count = params[:count].to_i  
    students.each do |student|
      if student.courses.count == count
        student_name << student.user.name
      end
    end
    if student_name.blank?
      render json:{message:"There is no student in enrolled in #{count} courses"},status: :internal_server_error
    else
      render json:student_name,status: :ok
    end
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
