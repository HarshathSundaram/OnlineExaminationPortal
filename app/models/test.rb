class Test < ApplicationRecord
  belongs_to :testable, polymorphic: true
  has_many :test_histories, dependent: :destroy
end
