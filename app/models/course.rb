class Course < ApplicationRecord
  belongs_to :instructor
  has_many :topics, dependent: :destroy
  has_many :tests, as: :testable, dependent: :destroy

  validates :name, presence: :true
  validates :category, presence: :true

end
