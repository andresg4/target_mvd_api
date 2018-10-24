require 'rails_helper'
require 'json'

describe 'GET api/v1/users/password/edit', type: :request do
  let(:params) { FactoryBot.attributes_for(:user) }
  let(:params_edit_password) do
    { reset_password_token: params[:email], redirect_url: Faker::Internet.url }
  end
  before(:each) { sign_up }

  context 'valid request' do
    before do
      user = User.find_by_email(params[:email])
      params_edit_password[:reset_password_token] = user.send_reset_password_instructions
      params_edit_password[:redirect_url] = Faker::Internet.url
      get edit_user_password_path, params: params_edit_password
    end
    it 'returns status 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns user email' do
      expect(json['email']).to eq(params[:email])
    end

    it 'returns headers' do
      expect(response.has_header?('access-token')).to eq(true)
      expect(response.has_header?('uid')).to eq(true)
      expect(response.has_header?('client')).to eq(true)
    end
  end

  context 'invalid request' do
    before do
      params_edit_password[:reset_password_token] = Faker::Internet.password(10, 20)
      params_edit_password[:redirect_url] = Faker::Internet.url
      get edit_user_password_path, params: params_edit_password
    end
    it 'returns status 404 not found' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns error message' do
      expect(json['errors'][0]).to eq('Not Found')
    end
  end
end
