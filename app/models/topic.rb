class Topic < ApplicationRecord
  has_many :tests, as: :testable
  belongs_to :course
end
