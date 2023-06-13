class Instructor < ApplicationRecord
    has_many :courses, dependent: :destroy

    validates :name , presence: :true
    validates :email , presence: :true
    validates :gender , presence: :true
    validates :designation , presence: :true
end
