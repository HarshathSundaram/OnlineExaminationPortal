class Api::InstructorsController < Api::ApiController
  before_action :is_instructor?, except: [:instructorsWithDesignation, :moreThanCourses]
  def show
    # @user = current_user
    # @instructor = Instructor.find_by(id:@user.userable_id)

    instructor = Instructor.find_by(id: params[:id])
    if instructor
        name = instructor.user.name
        render json:{"name": name,"Instructor": instructor}, status: :ok
    else
        render json:{message: "Instructor not found"}, status: :not_found
    end
  end

  def instructorsWithDesignation
    instructor_name=[]
    instructors = Instructor.all
    designation = params[:designation].downcase
    instructors.each do |instructor|
      if instructor.designation.downcase == designation
            instructor_name<<instructor.user.name
      end
    end
    if instructor_name.blank?
      render json:{message:"No instructor with designation #{designation}"},status: :internal_server_error
    else
      render json:instructor_name,status: :ok
    end
  end

  def moreThanCourses
    instructor_name=[]
    instructors = Instructor.all
    count = params[:count].to_i
    instructors.each do |instructor|
      if instructor.courses.count == count
            instructor_name<<instructor.user.name
      end
    end
    if instructor_name.blank?
      render json:{message:"No instructor with #{count} courses"},status: :internal_server_error
    else
      render json:instructor_name,status: :ok
    end
  end
  private
  def is_instructor?
      unless user_signed_in? && current_user.userable_type == "Instructor"
          render json:{message:"You are not allowed to access instructor"},status: :forbidden
      end
      instructor = Instructor.find_by(id:params[:id])
      if instructor
        unless current_user.userable == instructor
          render json:{message:"You have access to this instructor"}, status: :forbidden
        end 
      else
        render json:{message:"Instructor not found"}, status: :not_found
      end 
  end

end
