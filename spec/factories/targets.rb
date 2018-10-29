FactoryBot.define do
  factory :target, class: Target do
    sequence(:title) { |n| "#{n} #{Faker::Job.field[0, 15]}" }
    radius { Faker::Number.number(3) }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    topic_id { create(:topic).id }
    user_id { create(:user).id }
  end

  factory :target_create, class: Target do
    target { attributes_for(:target) }
  end

  factory :target_user, class: Target do
    sequence(:title) { |n| "#{n} #{Faker::Job.field[0, 15]}" }
    radius { Faker::Number.number(3) }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    topic_id { create(:topic).id }
    user
  end
end
