class Course < ApplicationRecord
  has_and_belongs_to_many :students, uniq: true
  belongs_to :instructor
  has_many :topics, dependent: :destroy
  has_many :tests, as: :testable, dependent: :destroy

  validates :name, presence: :true
  validates :category, presence: :true

end
