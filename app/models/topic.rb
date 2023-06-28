class Topic < ApplicationRecord
  has_many :tests, as: :testable, dependent: :destroy
  belongs_to :course
  has_one_attached :notes
  validate :validate_notes_presence
  validates :name, presence: :true, length:{minimum:3,maximum:20}
  validates :description, presence: :true, length:{minimum:10,maximum:50}

  def validate_notes_presence
    errors.add(:notes, "must be attached") unless notes.attached?
  end
end
