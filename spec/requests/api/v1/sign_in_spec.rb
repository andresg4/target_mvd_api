require 'rails_helper'
require 'json'

describe 'POST api/v1/users/sign_in', type: :request do
  let(:params)       { FactoryBot.attributes_for(:user) }
  let(:params_login) { { email: params[:email], password: params[:password] } }
  before(:each, confirm_email: true) do
    sign_up
  end

  context 'signs in successfully', confirm_email: true do
    it 'returns status 200 OK' do
      post user_session_path, params: params_login, as: :json
      expect(response).to have_http_status(:ok)
    end

    it 'gives an access token' do
      post user_session_path, params: params_login, as: :json
      expect(response.has_header?('access-token')).to eq(true)
    end
  end

  context 'signs in fails' do
    context 'wrong password', confirm_email: true do
      it 'returns status 401 Unauthorized' do
        params[:password] = '123'
        post user_session_path, params: params_login, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns errors' do
        params[:password] = '123'
        post user_session_path, params: params_login, as: :json
        expect(json['errors'][0]).to eq(I18n.t('devise_token_auth.sessions.bad_credentials'))
      end
    end

    context 'wrong email', confirm_email: true do
      it 'returns status 401 Unauthorized' do
        params[:email] = 'asd@asd.com'
        post user_session_path, params: params_login, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns errors' do
        params[:email] = 'asd@asd.com'
        post user_session_path, params: params_login, as: :json
        expect(json['errors'][0]).to eq(I18n.t('devise_token_auth.sessions.bad_credentials'))
      end
    end

    context 'unconfirmed email' do
      it 'returns status 401 Unauthorized' do
        post user_registration_path, params: params, as: :json
        post user_session_path, params: params_login, as: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns errors' do
        post user_registration_path, params: params, as: :json
        post user_session_path, params: params, as: :json
        expect(json['errors'][0]).to eq(I18n.t('devise_token_auth.sessions.not_confirmed',
                                               email: params[:email]))
      end
    end
  end
end
