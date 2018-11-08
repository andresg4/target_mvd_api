FactoryBot.define do
  factory :user, class: User do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.safe_email }
    gender                { Faker::Number.between(0, 1) }
    password              { 'password123' }
    password_confirmation { 'password123' }

    factory :user_with_targets do
      transient do
        targets_count { 10 }
      end

      after(:create) do |user, evaluator|
        create_list(:target, evaluator.targets_count, user: user)
      end
    end
  end

  factory :user_with_devices, class: User do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.safe_email }
    gender                { Faker::Number.between(0, 1) }
    password              { 'password123' }
    password_confirmation { 'password123' }
    transient do
      devices_count { 2 }
    end

    after(:create) do |user, evaluator|
      create_list(:device, evaluator.devices_count, user: user)
    end
  end

  factory :facebook_user, class: User do
    access_token          { Faker::Name.name }
  end
end
