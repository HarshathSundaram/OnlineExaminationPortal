class Course < ApplicationRecord
  belongs_to :instructors
  has_many :topics, dependent: :destroy
  has_many :tests, as: :testable
end
