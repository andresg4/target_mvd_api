FactoryBot.define do
  factory :device do
    sequence(:device_id) { |n| "#{n}#{Faker::Number.between(1, 100)}" }
    user
  end
end
