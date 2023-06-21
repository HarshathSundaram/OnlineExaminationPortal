class Course < ApplicationRecord
  has_and_belongs_to_many :students, uniq: true
  belongs_to :instructor
  has_many :topics, dependent: :destroy
  has_many :tests, as: :testable, dependent: :destroy
  has_one_attached :notes
  validate :validate_notes_presence
  validates :name, presence: :true
  validates :category, presence: :true

  def validate_notes_presence
    errors.add(:notes, "must be attached") unless notes.attached?
  end
end
