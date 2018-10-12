require 'rails_helper'

describe User, type: :model do
  let(:user) { FactoryBot.build(:random_user) }

  describe 'attributes' do
    # Validation tests
    it { expect(user).to validate_presence_of(:username) }
    it { expect(user).to validate_length_of(:username) }

    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_uniqueness_of(:email).ignoring_case_sensitivity }

    it { expect(user).to validate_presence_of(:gender) }
    it { expect(user).to validate_presence_of(:password) }

    it { expect(user).to define_enum_for(:gender).with_values(%i[masculino femenino]) }

    it 'saves attributes' do
      expect(user.save).to be true
    end
  end
end
