FactoryBot.define do
  factory :message, class: Message do
    body            { Faker::Community.quotes }
    conversation_id { create(:conversation).id }
    user_id         { create(:user).id }
    read            { false }
  end

  factory :message_create, class: Message do
    message { attributes_for(:message).except(:user_id, :read) }
  end
end
