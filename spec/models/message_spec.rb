require 'rails_helper'

describe Message, type: :model do
  subject { build(:message) }

  describe 'attributes' do
    it { is_expected.to validate_presence_of(:body) }

    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to belong_to(:user) }
  end

  it 'saves attributes' do
    expect(subject.save).to be true
  end
end
