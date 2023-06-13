class Student < ApplicationRecord
   validates :name , presence: :true
   validates :email , presence: :true
   validates :gender , presence: :true
   validates :department , presence: :true
   validates :year , presence: :true 
end
