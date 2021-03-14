FactoryBot.define do
  factory :task do
    title { "test_title" }
    status { "todo" }
    association :user
  end
end
