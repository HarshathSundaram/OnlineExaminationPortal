FactoryBot.define do
  factory :test_history do
    mark_scored {7}    
    total_mark {10}
    student
    test
  end
end
