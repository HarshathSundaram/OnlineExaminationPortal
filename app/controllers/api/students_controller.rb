class Api::StudentsController < Api::ApiController
  before_action :is_student?, except: [:studentsOfDepartment, :studentEnrolledCourses]
  def show
    # @user = current_user
    # @student = Student.find_by(id:@user.userable_id)
    student = Student.find_by(id:params[:id])
    name = student.user.name
    render json:{"name": name,"Student": student}, status: :ok
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
      render json:{message:'You have no access to student'},status: :forbidden
    end
    student = Student.find_by(id:params[:id])
    if student
      unless current_user.userable == student
        render json:{message:"You haved no access to another student"}, status: :forbidden
      end
    else
      render json:{message:"Student Not found"}, status: :forbidden
    end  
  end
end
