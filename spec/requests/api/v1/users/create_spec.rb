require 'rails_helper'
require 'factories/users.rb'
require 'json'

describe 'POST api/v1/users/', type: :request do
  let(:user) { FactoryBot.build(:random_user) }

  let(:params) { { user: FactoryBot.attributes_for(:random_user) } }

  let(:blank_params) { { user: {} } }

  let(:blank_params_response) do
    {
      'error' =>
      {
        'email' => [I18n.t('activerecord.errors.messages.blank')],
        'username' => [I18n.t('activerecord.errors.messages.blank')],
        'gender' => [I18n.t('activerecord.errors.messages.blank')],
        'password' => [I18n.t('activerecord.errors.messages.blank')],
        'password_confirmation' => [I18n.t('activerecord.errors.messages.blank')]
      }
    }
  end

  let(:wrong_email_params) { { user: FactoryBot.attributes_for(:user_invalid_email) } }
  let(:short_pass_params) { { user: FactoryBot.attributes_for(:user_short_password) } }
  let(:wrong_pass_params) { { user: FactoryBot.attributes_for(:user_wrong_password) } }

  context 'signs up successfully' do
    it 'returns status 200 OK' do
      post user_registration_path, params: params, as: :json
      expect(response.status).to eq(200)
    end

    it 'creates the user' do
      expect {
        post user_registration_path, params: params, as: :json
      }.to change { User.count }.by(1)
    end

    it 'saves the user correctly' do
      post user_registration_path, params: params, as: :json
      new_user = User.find_by_email(params[:user][:email])
      expect(new_user.username).to eq(params[:user][:username])
      expect(new_user.email).to eq(params[:user][:email])
      expect(new_user.gender).to eq(User.genders.key(params[:user][:gender]))
    end
  end

  context 'sign up fails' do
    context 'blank parameters' do
      it 'returns 400 bad request' do
        post user_registration_path, params: blank_params, as: :json
        expect(response.status).to eq(400)
      end

      it 'returns errors' do
        post user_registration_path, params: blank_params, as: :json
        expect(json).to eq(blank_params_response)
      end
    end

    context 'existing email' do
      it 'returns 400 bad request' do
        post user_registration_path, params: params, as: :json
        post user_registration_path, params: params, as: :json
        expect(response.status).to eq(400)
      end

      it 'returns existing email error' do
        post user_registration_path, params: params, as: :json
        post user_registration_path, params: params, as: :json
        expect(json['error']['email'][0]).to eq(I18n.t('activerecord.errors.messages.taken'))
      end
    end

    context 'invalid email' do
      it 'returns 400 bad request' do
        post user_registration_path, params: wrong_email_params, as: :json
        expect(response.status).to eq(400)
      end

      it 'returns invalid mail error' do
        post user_registration_path, params: wrong_email_params, as: :json
        expect(json['error']['email'][0]).to eq(I18n.t('activerecord.errors.messages.invalid'))
      end
    end

    context 'short password' do
      it 'returns 400 bad request' do
        post user_registration_path, params: short_pass_params, as: :json
        expect(response.status).to eq(400)
      end

      it 'returns short pass error' do
        post user_registration_path, params: short_pass_params, as: :json
        j = json['error']['password'][0]
        expect(j).to eq(I18n.t('activerecord.errors.models.user.attributes.password.too_short',
                               count: Devise.password_length.min))
      end
    end

    context 'password confirmation does not match' do
      it 'returns 400 bad request' do
        post user_registration_path, params: wrong_pass_params, as: :json
        expect(response.status).to eq(400)
      end

      it 'returns short pass error' do
        post user_registration_path, params: wrong_pass_params, as: :json
        j = json['error']['password_confirmation'][0]
        expect(j).to eq(I18n.t('activerecord.errors.messages.confirmation'))
      end
    end
  end
end
