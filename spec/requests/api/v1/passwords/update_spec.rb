require 'rails_helper'
require 'json'

describe 'PUT api/v1/users/password', type: :request do
  let(:params)                  { FactoryBot.attributes_for(:user) }
  let(:pass_nuevo)              { Faker::Internet.password(8, 20) }
  let(:params_update_password)  { { password: pass_nuevo, password_confirmation: pass_nuevo } }
  let(:headers_update) do
    {
      'access-token': Faker::Internet.password(10, 20),
      client: Faker::Internet.password(8, 15),
      uid: Faker::Internet.safe_email
    }
  end
  before(:each) { sign_up }

  context 'valid request' do
    before do
      put user_password_path, params: params_update_password, headers: update_password_headers(
        User.find_by_email(params[:email])
      ), as: :json
    end
    it 'returns status 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns success message' do
      expect(json['success']).to eq(true)
      expect(json['message']).to eq(I18n.t('devise_token_auth.passwords.successfully_updated'))
      expect(json['data']['email']).to eq(params[:email])
    end
  end

  context 'invalid request' do
    before do
      put user_password_path, params: params_update_password, headers: headers_update, as: :json
    end
    it 'returns status 401 not authorized' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error message' do
      expect(json['errors'][0]).to eq('Unauthorized')
    end
  end
end
