class Course < ApplicationRecord
  paginates_per 8
  has_and_belongs_to_many :students, uniq: true
  belongs_to :instructor
  has_many :topics, dependent: :destroy
  has_many :tests, as: :testable, dependent: :destroy
  has_one_attached :notes
  validates :name, presence: :true, length:{minimum: 3, maximum:20}
  validates :category, presence: :true, length:{minimum: 3, maximum:50}

  scope :course_with_greater_than_5_topic, -> { joins(:topics).group('courses.id').having('COUNT(topics.id) >= 5') }
  scope :course_with_less_than_5_topic, -> { joins(:topics).group('courses.id').having('COUNT(topics.id) < 5') }

 
end
