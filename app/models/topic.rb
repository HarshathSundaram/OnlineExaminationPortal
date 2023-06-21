class Topic < ApplicationRecord
  has_many :tests, as: :testable, dependent: :destroy
  belongs_to :course
  has_one_attached :notes
  validate :validate_notes_presence
  validates :name, presence: :true
  validates :description, presence: :true

  def validate_notes_presence
    errors.add(:notes, "must be attached") unless notes.attached?
  end
end
