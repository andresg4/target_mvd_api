require 'rails_helper'
require 'json'

describe 'POST api/v1/users/facebook', type: :request do
  context 'valid request' do
    subject do
      post api_v1_users_sign_in_facebook_path,
           params: {
             access_token: '12345'
           },
           as: :json
    end

    context 'new user' do
      it 'returns status 200 OK' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'gives an access token' do
        subject
        expect(response.has_header?('access-token')).to eq(true)
      end

      it 'creates the user' do
        expect {
          subject
        }.to change { User.count }.by(1)
      end
    end

    context 'user already exists' do
      before { subject }

      it 'returns status 200 OK' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'gives an access token' do
        subject
        expect(response.has_header?('access-token')).to eq(true)
      end

      it 'does not create an user' do
        expect {
          subject
        }.not_to change { User.count }
      end
    end
  end

  context 'invalid request' do
    context 'without permission to obtain email' do
      subject do
        post api_v1_users_sign_in_facebook_path,
             params: {
               access_token: '1234'
             },
             as: :json
      end

      it 'returns status 401 Unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error' do
        subject
        expect(json['errors'][0]).to eq(I18n.t('api.facebook.missing_permissions_to_get_email'))
      end
    end

    context 'invalid access token' do
      subject do
        post api_v1_users_sign_in_facebook_path,
             params: {
               access_token: '123'
             },
             as: :json
      end

      it 'returns status 403 Forbidden' do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns error' do
        subject
        expect(json['errors'][0]).to eq(I18n.t('api.facebook.not_authorized'))
      end
    end
  end
end
