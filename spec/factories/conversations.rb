FactoryBot.define do
  factory :conversation, class: Conversation do
    user_one { create(:user) }
    user_two { create(:user) }
  end
end
