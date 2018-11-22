require 'rails_helper'

describe Conversation, type: :model do
  subject { build(:conversation) }

  describe 'attributes' do
    it { is_expected.to validate_uniqueness_of(:user_one_id).scoped_to(:user_two_id) }

    it { is_expected.to belong_to(:user_one) }
    it { is_expected.to belong_to(:user_two) }

    it { is_expected.to have_many(:messages) }
  end

  it 'saves attributes' do
    expect(subject.save).to be true
  end
end
