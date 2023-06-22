class Instructor < ApplicationRecord
    has_many :courses, dependent: :destroy
    has_one :user, as: :userable, dependent: :destroy
    validates :designation , presence: :true

    scope :instructor_with_more_than_5_course, -> { joins(:courses).group('instructors.id').having('COUNT(courses.id) >= 5') }
    scope :instructor_with_less_than_5_course, -> { joins(:courses).group('instructors.id').having('COUNT(courses.id) < 5') }

end
