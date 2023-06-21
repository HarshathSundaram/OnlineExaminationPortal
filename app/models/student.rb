class Student < ApplicationRecord
   has_and_belongs_to_many :courses, uniq: true
   has_many :test_histories, dependent: :destroy
   has_one :user, as: :userable, dependent: :destroy
   has_one :latest_test_history, -> { order(created_at: :desc) }, class_name: 'TestHistory'
   has_one :latest_test, through: :latest_test_history, source: :test
   before_destroy :remove_associations 
   validates :department , presence: :true
   validates :year , presence: :true 
end
