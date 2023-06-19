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

  #Course and Topic Test Routes
  get 'course/:course_id/question', to: 'tests#newcoursequestions', as: 'test_course_question'
  post 'course/:course_id/question', to: 'tests#createcoursequestions', as: 'test_course_create'
  get 'course/:course_id/tests', to: 'tests#showcoursetests', as: 'test_course'
  delete 'course/:course_id/test/:test_id', to: 'tests#destroycoursetests', as: 'test_course_delete'


  get 'topic/:topic_id/question', to: 'tests#newtopicquestions', as: 'test_topic_question'
  post 'topic/:topic_id/question', to: 'tests#createtopicquestions', as: 'test_topic_create'
  get 'topic/:topic_id/tests', to: 'tests#showtopictests', as: 'test_topic'
  get 'topic/:topic_id/tests/:test_id', to: 'tests#showtopicquestions', as: 'test_topic_show'
  delete 'topic/:topic_id/tests/:test_id', to: 'tests#destroytopictests', as: 'test_topic_delete'


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
  get 'student/:student_id/course/:course_id/test_history', to: 'test_histories#studentCourseHistory', as: 'student_course_history'
  get 'student/:student_id/course/:course_id/test/:test_id/test_history', to: 'test_histories#studentCourseTestHistory', as: 'student_course_test_history'
  get 'student/:student_id/course/:course_id/topic/:topic_id/test_history', to: 'test_histories#studentTopicHistory', as: 'student_topic_history'
  get 'student/:student_id/course/:course_id/topic/:topic_id/test/:test_id/test', to: 'test_histories#studentTopicTestHistory', as: 'student_topic_test_history'
  get 'student/:student_id/test_history/:test_history_id', to: 'test_histories#showTestHistory', as: 'student_test_history'


end