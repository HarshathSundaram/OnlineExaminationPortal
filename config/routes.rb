Rails.application.routes.draw do
  root 'landing#index'

  resources :students
  resources :instructors do
    resources :courses
  end

  resources :courses do
    resources :topics
  end

  #Students Courses
  get 'students/:student_id/allcourses', to: 'students_courses#index', as:'student_course'
  get 'students/:student_id/course/:course_id/enroll', to: 'students_courses#enroll', as: 'student_course_enroll'
  get 'students/:student_id/course/:course_id/unenroll', to: 'students_courses#unenroll', as: 'student_course_unenroll'
  get 'students/:student_id/course/:course_id/showcourse', to: 'students_courses#showcourse', as: 'student_course_course'
  get 'students/:student_id/course/:course_id/topic/:topic_id', to: 'students_courses#showtopic', as: 'student_course_topic'

  #Students Routes
  get 'students', to: 'students#index', as: 'student_index'


  #Instructors Routes
  get 'instructors', to: 'instructors#index', as: 'instructor_index'

 
  #Instructor Course Routes 


end