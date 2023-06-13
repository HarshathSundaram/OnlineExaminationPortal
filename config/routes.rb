Rails.application.routes.draw do
  root 'landing#index'

  #Students Routes
  get 'students', to: 'students#index'
  get 'students/new', to: 'students#new', as: 'new_student'
  post 'students', to: 'students#create'
  get 'students/:id', to: 'students#show', as: 'student'
  get 'students/edit/:id', to: 'students#edit', as: 'edit_student'
  patch 'students/:id', to: 'students#update'
  delete 'students/:id', to: 'students#destroy'

  #Instructors Routes
  get 'instructors', to: 'instructors#index'
  get 'instructors/new', to: 'instructors#new', as: 'new_instructor'
  post 'instructors', to:'instructors#create'
  get 'instructors/:id', to: 'instructors#show', as: 'instructor'
  get 'instructors/edit/:id', to: 'instructors#edit', as: 'edit_instructor'
  patch 'instructors/:id', to: 'instructors#update' 
  delete 'instructors/:id', to: 'instructors#delete'
  
end