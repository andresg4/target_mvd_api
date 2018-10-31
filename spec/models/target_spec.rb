require 'rails_helper'

describe Target, type: :model do
  subject { build(:target) }

  describe 'attributes' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).ignoring_case_sensitivity }

    it { is_expected.to validate_presence_of(:radius) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }

    it { is_expected.to validate_numericality_of(:radius) }

    it { is_expected.to belong_to(:topic) }
    it { is_expected.to belong_to(:user) }
  end

  it 'saves attributes', create_user_and_topic: true do
    expect(subject.save).to be true
  end
end
