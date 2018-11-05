require 'rails_helper'
require 'json'

describe 'POST api/v1/users/', type: :request do
  let(:params)             { FactoryBot.attributes_for(:user) }
  let(:blank_params)       { {} }
  let(:wrong_email_params) do
    FactoryBot.attributes_for(:user, email: 'johnexample.com')
  end
  let(:short_pass_params) do
    FactoryBot.attributes_for(:user, password: '123', password_confirmation: '123')
  end
  let(:wrong_pass_params) do
    FactoryBot.attributes_for(:user, password_confirmation: 'passwordconfirmation')
  end

  context 'signs up successfully' do
    it 'returns status 200 OK' do
      post user_registration_path, params: params, as: :json
      expect(response).to have_http_status(:ok)
    end

    it 'creates the user' do
      expect {
        post user_registration_path, params: params, as: :json
      }.to change { User.count }.by(1)
    end

    it 'saves the user correctly' do
      post user_registration_path, params: params, as: :json
      new_user = User.find_by_email(params[:email])
      expect(new_user.name).to eq(params[:name])
      expect(new_user.email).to eq(params[:email])
      expect(new_user.gender).to eq(User.genders.key(params[:gender]))
    end

    it 'sends confirmation email' do
      post user_registration_path, params: params, as: :json
      new_user = User.find_by_email(params[:email])
      confirmation_email = Devise.mailer.deliveries.last
      expect(new_user.email).to eq confirmation_email.to[0]
      expect(confirmation_email.body.encoded)
        .to include I18n.t('devise.mailer.confirmation_instructions.confirm_link_msg')
    end
  end

  context 'sign up fails' do
    context 'blank parameters' do
      it 'returns 422 unprocessable entity' do
        post user_registration_path, params: blank_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors' do
        post user_registration_path, params: blank_params, as: :json
        expect(json['errors']).to eq(I18n.t('errors.messages.validate_sign_up_params'))
      end
    end

    context 'existing email' do
      it 'returns 422 unprocessable entity' do
        post user_registration_path, params: params, as: :json
        post user_registration_path, params: params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns existing email error' do
        post user_registration_path, params: params, as: :json
        post user_registration_path, params: params, as: :json
        expect(json['errors']['email'][0]).to eq(I18n.t('errors.messages.taken'))
      end
    end

    context 'invalid email' do
      it 'returns 422 unprocessable entity' do
        post user_registration_path, params: wrong_email_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns invalid mail error' do
        post user_registration_path, params: wrong_email_params, as: :json
        expect(json['errors']['email'][0]).to eq(I18n.t('errors.messages.not_email'))
      end
    end

    context 'short password' do
      it 'returns 422 unprocessable entity' do
        post user_registration_path, params: short_pass_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns short pass error' do
        post user_registration_path, params: short_pass_params, as: :json
        expect(json['errors']['password'][0])
          .to eq(I18n.t('activerecord.errors.models.user.attributes.password.too_short',
                        count: Devise.password_length.min))
      end
    end

    context 'password confirmation does not match' do
      it 'returns 422 unprocessable entity' do
        post user_registration_path, params: wrong_pass_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns short pass error' do
        post user_registration_path, params: wrong_pass_params, as: :json
        expect(json['errors']['password_confirmation'][0])
          .to eq(I18n.t('activerecord.errors.messages.confirmation'))
      end
    end
  end
end
