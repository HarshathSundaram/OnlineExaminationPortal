class Test < ApplicationRecord
  belongs_to :testable, polymorphic: true
  has_many :test_histories, dependent: :destroy

  scope :test_attended_which_more_than_5, -> {joins(:test_histories).group('tests.id').having('COUNT(test_histories.id) >= 5')}
  scope :test_attended_which_less_than_5, -> {joins(:test_histories).group('tests.id').having('COUNT(test_histories.id) < 5')}

end
