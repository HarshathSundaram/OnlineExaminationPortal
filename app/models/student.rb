class Student < ApplicationRecord
   has_and_belongs_to_many :courses, uniq: true
   has_many :test_histories, dependent: :destroy
   has_many :tests, through: :courses
   has_one :user, as: :userable, dependent: :destroy
   has_one :latest_test_history, -> { order(created_at: :desc) }, class_name: 'TestHistory'
   has_one :latest_test, through: :latest_test_history, source: :test
   before_destroy :remove_associations 

   validates :department , presence: :true
   validates :year , presence: :true

   before_create :change_department?
   
   scope :student_enrolled_more_than_5_course, -> { joins(:courses).group('students.id').having('COUNT(courses.id) >= 5 ') }
   scope :student_enrolled_less_than_5_course, -> { joins(:courses).group('students.id').having('COUNT(courses.id) < 5 ') }


   def change_department?
      self.department.upcase!      
   end
end
