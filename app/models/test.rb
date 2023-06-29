class Test < ApplicationRecord
  belongs_to :testable, polymorphic: true
  has_many :test_histories, dependent: :destroy
  validate :validate_questions_json_format
  validates :name, presence: true, length:{minimum:2,maximum:30}
  scope :test_attended_which_more_than_5, -> {joins(:test_histories).group('tests.id').having('COUNT(test_histories.id) >= 5')}
  scope :test_attended_which_less_than_5, -> {joins(:test_histories).group('tests.id').having('COUNT(test_histories.id) < 5')}
  def validate_questions_json_format
    return unless questions.present?
    unless questions.is_a?(Array)
      errors.add(:questions, "must be an array")
      return
    end
    questions.each_with_index do |question, index|
      unless question_valid?(question)
        errors.add(:questions, "has an invalid format for question #{index}")
      end
    end
  rescue JSON::ParserError
    errors.add(:questions, "is not a valid JSON format")
  end

  def question_valid?(question)
    question['question'].present? &&
      question['options'].is_a?(Hash) &&
      question['answer'].present? &&
      question['mark'].present?
  end
end


