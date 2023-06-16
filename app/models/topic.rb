class Topic < ApplicationRecord
  has_many :tests, as: :testable, dependent: :destroy
  belongs_to :course
end
