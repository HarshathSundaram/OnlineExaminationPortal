class Course < ApplicationRecord
  belongs_to :instructor
  has_many :topics, dependent: :destroy
  has_many :tests, as: :testable
end
