class Test < ApplicationRecord
  belongs_to :testable, polymorphic: true
  has_many :test_histories, dependent: :destroy
  validate :validate_questions_json_format
  validates :name, presence: true, length:{minimum:3,maximum:20}
  scope :test_attended_which_more_than_5, -> {joins(:test_histories).group('tests.id').having('COUNT(test_histories.id) >= 5')}
  scope :test_attended_which_less_than_5, -> {joins(:test_histories).group('tests.id').having('COUNT(test_histories.id) < 5')}
  def validate_questions_json_format
    unless questions.present?
      self.errors.add(:questions,"Please add questions")
    end
    unless questions.is_a?(Array)
      self.errors.add(:questions, "must be an array")
      return
    end
    questions.each_with_index do |question, index|
      unless question_valid?(question)
        self.errors.add(:questions, "has an invalid format for question #{index}")
      end
    end
  rescue JSON::ParserError
    self.errors.add(:questions, "is not a valid JSON format")
  end

  def question_valid?(question)
    question['question'].present? &&
      question['options'].is_a?(Hash) &&
      question['answer'].present? &&
      question['mark'].present?
  end
end


