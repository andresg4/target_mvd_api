FactoryBot.define do
  factory :user, class: User do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.safe_email }
    gender                { Faker::Number.between(0, 1) }
    password              { 'password123' }
    password_confirmation { 'password123' }
  end

  factory :facebook_user, class: User do
    access_token          { Faker::Name.name }
  end
end
