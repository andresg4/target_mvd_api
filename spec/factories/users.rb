FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'john.doe@example.com' }
    gender { 0 }
    password { 'password123' }
    password_confirmation { 'password123' }
  end

  factory :random_user, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    gender { Faker::Number.between(0, 1) }
    password { 'password123' }
    password_confirmation { 'password123' }
  end

  factory :user_invalid_email, class: User do
    name { Faker::Name.name }
    email { 'johnexample.com' }
    gender { Faker::Number.between(0, 1) }
    password { 'password123' }
    password_confirmation { 'password123' }
  end

  factory :user_short_password, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    gender { Faker::Number.between(0, 1) }
    password { '123' }
    password_confirmation { '123' }
  end

  factory :user_wrong_password, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    gender { Faker::Number.between(0, 1) }
    password { 'password123' }
    password_confirmation { 'passwordconfirmation' }
  end
end
