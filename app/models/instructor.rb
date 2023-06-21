class Instructor < ApplicationRecord
    has_many :courses, dependent: :destroy
    has_one :user, as: :userable, dependent: :destroy
    validates :designation , presence: :true
end
