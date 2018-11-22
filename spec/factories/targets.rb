FactoryBot.define do
  factory :target, class: Target do
    sequence(:title)  { |n| "#{n} #{Faker::Job.field[0, 15]}" }
    radius            { Faker::Number.between(20, 1000) }
    latitude          { Faker::Address.latitude }
    longitude         { Faker::Address.longitude }
    topic
    user
  end
end
