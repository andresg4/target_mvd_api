FactoryBot.define do
  factory :conversation do
    user_one { create(:user) }
    user_two { create(:user) }
  end
end
