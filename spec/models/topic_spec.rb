require 'rails_helper'

describe Topic, type: :model do
  subject { build(:topic) }

  describe 'attributes' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }

    xit { is_expected.to have_many(:targets) }
  end

  it 'saves attributes' do
    expect(subject.save).to be true
  end
end
