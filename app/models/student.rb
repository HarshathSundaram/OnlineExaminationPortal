class Student < ApplicationRecord
   has_and_belongs_to_many :courses, uniq: true
   validates :name , presence: :true
   validates :email , presence: :true
   validates :gender , presence: :true
   validates :department , presence: :true
   validates :year , presence: :true 
end
