require 'rails_helper'

describe Device, type: :model do
  subject { build(:device) }

  describe 'attributes' do
    it { is_expected.to validate_presence_of(:device_id) }
    it { is_expected.to validate_uniqueness_of(:device_id).ignoring_case_sensitivity }

    it { is_expected.to belong_to(:user) }
  end

  it 'saves attributes' do
    expect(subject.save).to be true
  end
end
