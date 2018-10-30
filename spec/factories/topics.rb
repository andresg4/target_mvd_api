FactoryBot.define do
  factory :topic, class: Topic do
    sequence(:name) { |n| "#{n} #{Faker::Job.field}" }
  end
end
