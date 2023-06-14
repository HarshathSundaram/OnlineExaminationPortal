Rails.application.routes.draw do
  root 'landing#index'

  resources :students
  resources :instructors do
    resources :courses
  end

  resources :courses do
    resources :topics
  end

  #Students Routes
  get 'students', to: 'students#index', as: 'student_index'


  #Instructors Routes
  get 'instructors', to: 'instructors#index', as: 'instructor_index'

 
  #Instructor Course Routes 


end