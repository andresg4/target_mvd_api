require 'rails_helper'
require 'json'

describe 'UPDATE api/v1/users/', type: :request do
  let(:user)                { create(:user) }
  let(:user_email_repeated) { create(:user) }
  let(:params)              { FactoryBot.attributes_for(:user) }
  let(:wrong_email_params) do
    FactoryBot.attributes_for(:user, email: 'johnexample.com')
  end
  let(:short_pass_params) do
    FactoryBot.attributes_for(:user, password: '123', password_confirmation: '123')
  end

  before do
    user.confirm
    user_email_repeated.confirm
  end

  context 'updates successfully' do
    before { put api_v1_user_update_path, headers: headers_aux(user), params: params, as: :json }

    it 'returns status 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns updated user' do
      expect(json['email']).to eq(params[:email])
      expect(json['name']).to eq(params[:name])
    end

    it 'updates the user' do
      user.reload
      expect(user.name).to eq(params[:name])
      expect(user.email).to eq(params[:email])
      expect(user.password).to eq(params[:password])
    end
  end

  context 'updates fails' do
    context 'existing email' do
      before do
        params[:email] = user_email_repeated.email
        put api_v1_user_update_path, headers: headers_aux(user), params: params, as: :json
      end

      it 'returns 422 unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns existing email error' do
        expect(json['errors']['email'][0]).to eq(I18n.t('errors.messages.taken'))
      end
    end

    context 'invalid email' do
      before do
        put api_v1_user_update_path,
            headers: headers_aux(user),
            params: wrong_email_params,
            as: :json
      end

      it 'returns 422 unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns invalid mail error' do
        expect(json['errors']['email'][0]).to eq(I18n.t('errors.messages.not_email'))
      end
    end

    context 'short password' do
      before do
        put api_v1_user_update_path,
            headers: headers_aux(user),
            params: short_pass_params,
            as: :json
      end

      it 'returns 422 unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns short pass error' do
        expect(json['errors']['password'][0])
          .to eq(I18n.t('activerecord.errors.models.user.attributes.password.too_short',
                        count: Devise.password_length.min))
      end
    end
  end
end
