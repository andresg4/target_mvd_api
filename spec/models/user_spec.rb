require 'rails_helper'

describe User, type: :model do
  subject { build(:user) }

  describe 'attributes' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name) }

    it { is_expected.to validate_presence_of(:email) }
    it do
      is_expected.to validate_uniqueness_of(:email)
        .ignoring_case_sensitivity
        .scoped_to(:provider)
    end

    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to define_enum_for(:gender).with_values(male: 0, female: 1) }

    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }

    it { is_expected.to have_many(:targets) }

    it 'saves attributes' do
      expect(subject.save).to be true
    end
  end
end
