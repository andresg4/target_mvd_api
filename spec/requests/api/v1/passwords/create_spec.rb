require 'rails_helper'
require 'json'

describe 'POST api/v1/users/password', type: :request do
  let(:params)                { FactoryBot.attributes_for(:user) }
  let(:params_reset_password) { { email: params[:email], redirect_url: Faker::Internet.url } }
  before(:each)               { sign_up }

  context 'valid request' do
    before do
      post user_password_path, params: params_reset_password, as: :json
    end
    it 'returns status 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns success message' do
      expect(json['success']).to eq(true)
      expect(json['message']).to eq(I18n.t('devise_token_auth.passwords.sended',
                                           email: params_reset_password[:email]))
    end

    it 'sends email' do
      user = User.find_by_email(params_reset_password[:email])
      reset_pass_email = Devise.mailer.deliveries.last
      expect(user.email).to eq reset_pass_email.to[0]
      expect(reset_pass_email.body.encoded)
        .to include I18n.t('devise.mailer.reset_password_instructions.request_reset_link_msg')
    end
  end

  context 'invalid request' do
    context 'mail not found' do
      before do
        params_reset_password[:email] = 'exa@exa.com'
        post user_password_path, params: params_reset_password, as: :json
      end
      it 'returns status 404 not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns errors message' do
        expect(json['errors'][0]).to eq(I18n.t('devise_token_auth.passwords.user_not_found',
                                               email: params_reset_password[:email]))
      end
    end

    context 'without email' do
      before do
        params_reset_password = { redirect_url: 'url' }
        post user_password_path, params: params_reset_password, as: :json
      end
      it 'returns status 401 unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns errors message' do
        expect(json['errors'][0]).to eq(I18n.t('devise_token_auth.passwords.missing_email'))
      end
    end

    context 'without redirect url' do
      before do
        params_reset_password = { email: params[:email] }
        post user_password_path, params: params_reset_password, as: :json
      end
      it 'returns status 401 unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns errors message' do
        expect(json['errors'][0]).to eq(I18n.t('devise_token_auth.passwords.missing_redirect_url'))
      end
    end
  end
end
