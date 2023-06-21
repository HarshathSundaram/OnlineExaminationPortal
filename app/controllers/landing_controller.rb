class LandingController < ApplicationController
  def index
    if current_user.userable_type == "Student"
      redirect_to student_path(current_user.userable_id)
    elsif current_user.userable_type == "Instructor"
      redirect_to instructor_path(current_user.userable_id)
   end 
  end
end
