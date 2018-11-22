FactoryBot.define do
  factory :message, class: Message do
    body         { Faker::Community.quotes }
    conversation { create(:conversation, user_one: user) }
    user
  end
end
