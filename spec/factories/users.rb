FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@gmail.com"
    end
    name {"Harsath"}
    password {"Harsath"}
    password_confirmation {"Harsath"}
    gender {"Male"}
    trait :for_student do
      association :userable, factory: :student
    end

    trait :for_instructor do
      association :userable, factory: :instructor
    end
  end
end
