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
   validate :year_format

   before_create :change_department?

   private
   def year_format
      return if year.blank? || year.length != 1 || year.to_i.to_s != year

      errors.add(:year, "must be a single-digit number")
   end
   
   scope :student_enrolled_more_than_5_course, -> { joins(:courses).group('students.id').having('COUNT(courses.id) >= 5 ') }
   scope :student_enrolled_less_than_5_course, -> { joins(:courses).group('students.id').having('COUNT(courses.id) < 5 ') }


   def change_department?
      self.department.upcase!      
   end
end
