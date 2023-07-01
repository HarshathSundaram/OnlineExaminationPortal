class TestHistory < ApplicationRecord
    belongs_to :student
    belongs_to :test

    validates :mark_scored , presence: :true, numericality: { only_integer: true}
    validates :total_mark , presence: :true, numericality: { only_integer: true}    
    scope :mark_scored_greater_than_7, ->{TestHistory.where("mark_scored >= ?", 7)}
    scope :mark_scored_less_than_7, ->{TestHistory.where("mark_scored < ?", 7)}
end
