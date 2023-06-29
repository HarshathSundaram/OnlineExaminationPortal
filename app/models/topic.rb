class Topic < ApplicationRecord
  has_many :tests, as: :testable, dependent: :destroy
  belongs_to :course
  has_one_attached :notes
  validates :name, presence: :true, length:{minimum:3,maximum:20}
  validates :description, presence: :true, length:{minimum:10,maximum:150}
 
end
