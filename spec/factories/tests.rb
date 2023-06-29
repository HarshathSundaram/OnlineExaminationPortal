FactoryBot.define do
  factory :test do
    name {"Assignment Operators"}
    questions { [
      {
        "mark" => "1",
        "answer" => "checks a is not equal to b",
        "options" => {
          "0" => "assign a to b",
          "1" => "checks a is not equal to b",
          "2" => "Invalid Operator",
          "3" => "None"
        },
        "question" => "a!=b"
      }
    ] }
    trait :for_course do
      association :testable, factory: :course
    end

    trait :for_topic do
      association :testable, factory: :topic
    end
  end
end
