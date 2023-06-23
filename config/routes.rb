Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root 'landing#index'

  resources :students
  resources :instructors do
    resources :courses
  end

  resources :courses do
    resources :topics
  end

  #Course and Topic Notes route
  get 'instructor/:instructor_id/course/:course_id/newnotes', to: 'courses#newnotes', as: 'new_course_notes'
  post 'instructor/:instructor_id/course/:course_id/newnotes', to: 'courses#createnotes', as: 'create_course_notes'
  delete 'instructor/:instructor_id/course/:course_id/deleteNotes', to: 'courses#deletenotes', as: 'delete_course_notes'

  get 'course/:course_id/topic/:topic_id/newnotes', to: 'topics#newnotes', as: 'new_topic_notes'
  post 'course/:course_id/topic/:topic_id/newnotes', to: 'topics#createnotes', as: 'create_topic_notes'
  delete 'course/:course_id/topic/:topic_id/deleteNotes', to: 'topics#deletenotes', as: 'delete_topic_notes'

  #Students Courses
  get 'students/:student_id/allcourses', to: 'students_courses#index', as:'student_course'
  get 'students/:student_id/course/:course_id/enroll', to: 'students_courses#enroll', as: 'student_course_enroll'
  get 'students/:student_id/course/:course_id/unenroll', to: 'students_courses#unenroll', as: 'student_course_unenroll'
  get 'students/:student_id/course/:course_id/showcourse', to: 'students_courses#showcourse', as: 'student_course_course'
  get 'students/:student_id/course/:course_id/topic/:topic_id', to: 'students_courses#showtopic', as: 'student_course_topic'


  #Course and Topic Test Routes
  get 'course/:course_id/question', to: 'tests#newcoursequestions', as: 'test_course_question'
  post 'course/:course_id/question', to: 'tests#createcoursequestions', as: 'test_course_create'
  get 'course/:course_id/test/:test_id/question', to: 'tests#showcoursequestions', as: 'test_course_edit'
  patch 'course/:course_id/test/:test_id/question', to: 'tests#updatecoursequestions', as: 'test_course_edit_question'
  get 'course/:course_id/tests', to: 'tests#showcoursetests', as: 'test_course'
  delete 'course/:course_id/test/:test_id', to: 'tests#destroycoursetests', as: 'test_course_delete'


  get 'course/:course_id/topic/:topic_id/question', to: 'tests#newtopicquestions', as: 'test_topic_question'
  post 'course/:course_id/topic/:topic_id/question', to: 'tests#createtopicquestions', as: 'test_topic_create'
  get 'course/:course_id/topic/:topic_id/test/:test_id/question', to: 'tests#showtopicquestions', as: 'test_topic_edit'
  patch 'course/:course_id/topic/:topic_id/test/:test_id/question', to: 'tests#updatetopicquestions', as: 'test_topic_edit_question'
  get 'course/:course_id/topic/:topic_id/tests', to: 'tests#showtopictests', as: 'test_topic'
  get 'course/:course_id/topic/:topic_id/tests/:test_id', to: 'tests#showtopicquestions', as: 'test_topic_show'
  delete 'course/:course_id/topic/:topic_id/tests/:test_id', to: 'tests#destroytopictests', as: 'test_topic_delete'


  #Students Course and Topic Testes
  get 'student/:student_id/course/:course_id/tests', to: 'students_tests#showcoursetests', as: 'students_course_tests'
  get 'student/:student_id/course/:course_id/tests/:test_id', to: 'students_tests#takecoursetests', as: 'student_course_tests_take'
  post 'student/:student_id/course/:course_id/test/:test_id', to: 'students_tests#validatecoursetest', as: 'student_course_validate'
  get 'student/:student_id/course/:course_id/test/:test_id/result', to: 'students_tests#coursetestresult', as: 'student_course_result'

  get 'student/:student_id/course/:course_id/topic/:topic_id/tests', to: 'students_tests#showtopictests', as: 'students_topic_tests'
  get 'student/:student_id/course/:course_id/topic/:topic_id/tests/:test_id', to: 'students_tests#taketopictests', as: 'student_topic_tests_take'
  post 'student/:student_id/course/:course_id/topic/:topic_id/test/:test_id', to: 'students_tests#validatetopictest', as: 'student_topic_validate'
  get 'student/:student_id/course/:course_id/topic/:topic_id/test/:test_id/result', to: 'students_tests#topictestresult', as: 'student_topic_result'


  #Students Courses and topics test history
  get 'student/:student_id/test_history', to: 'test_histories#studentHistory', as: 'student_history'
  get 'student/:student_id/test_history/:test_history_id', to: 'test_histories#showTestHistory', as: 'student_test_history'

  
  
  
  
  
  #API Routes
  namespace :api , default: {format: :json} do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)


    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

    root 'landing#index'

  resources :students
  resources :instructors do
    resources :courses
  end

  resources :courses do
    resources :topics
  end

  #Course and Topic Notes route
  get 'instructor/:instructor_id/course/:course_id/newnotes', to: 'courses#newnotes', as: 'new_course_notes'
  post 'instructor/:instructor_id/course/:course_id/newnotes', to: 'courses#createnotes', as: 'create_course_notes'
  delete 'instructor/:instructor_id/course/:course_id/deleteNotes', to: 'courses#deletenotes', as: 'delete_course_notes'

  get 'course/:course_id/topic/:topic_id/newnotes', to: 'topics#newnotes', as: 'new_topic_notes'
  post 'course/:course_id/topic/:topic_id/newnotes', to: 'topics#createnotes', as: 'create_topic_notes'
  delete 'course/:course_id/topic/:topic_id/deleteNotes', to: 'topics#deletenotes', as: 'delete_topic_notes'

  #Students Courses
  get 'students/:student_id/allcourses', to: 'students_courses#index', as:'student_course'
  get 'students/:student_id/course/:course_id/enroll', to: 'students_courses#enroll', as: 'student_course_enroll'
  get 'students/:student_id/course/:course_id/unenroll', to: 'students_courses#unenroll', as: 'student_course_unenroll'
  get 'students/:student_id/course/:course_id/showcourse', to: 'students_courses#showcourse', as: 'student_course_course'
  get 'students/:student_id/course/:course_id/topic/:topic_id', to: 'students_courses#showtopic', as: 'student_course_topic'


  #Course and Topic Test Routes
  get 'course/:course_id/question', to: 'tests#newcoursequestions', as: 'test_course_question'
  post 'course/:course_id/question', to: 'tests#createcoursequestions', as: 'test_course_create'
  get 'course/:course_id/test/:test_id/question', to: 'tests#showcoursequestions', as: 'test_course_edit'
  patch 'course/:course_id/test/:test_id/question', to: 'tests#updatecoursequestions', as: 'test_course_edit_question'
  get 'course/:course_id/tests', to: 'tests#showcoursetests', as: 'test_course'
  delete 'course/:course_id/test/:test_id', to: 'tests#destroycoursetests', as: 'test_course_delete'


  get 'course/:course_id/topic/:topic_id/question', to: 'tests#newtopicquestions', as: 'test_topic_question'
  post 'course/:course_id/topic/:topic_id/question', to: 'tests#createtopicquestions', as: 'test_topic_create'
  get 'course/:course_id/topic/:topic_id/test/:test_id/question', to: 'tests#showtopicquestions', as: 'test_topic_edit'
  patch 'course/:course_id/topic/:topic_id/test/:test_id/question', to: 'tests#updatetopicquestions', as: 'test_topic_edit_question'
  get 'course/:course_id/topic/:topic_id/tests', to: 'tests#showtopictests', as: 'test_topic'
  get 'course/:course_id/topic/:topic_id/tests/:test_id', to: 'tests#showtopicquestions', as: 'test_topic_show'
  delete 'course/:course_id/topic/:topic_id/tests/:test_id', to: 'tests#destroytopictests', as: 'test_topic_delete'


  end


end