require 'rails_helper'
require 'json'

describe 'GET api/v1/users/me/targets', type: :request do
  let(:user_with_targets) { create(:user_with_targets) }

  before                  { user_with_targets.confirm }

  context 'valid request' do
    before { get api_v1_user_targets_path, headers: headers_aux(user_with_targets), as: :json }

    it 'returns status 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns user targets' do
      expect(json['targets'].map { |target| target['id'] })
        .to match_array(user_with_targets.targets.pluck(:id))
    end
  end
  include_examples 'invalid headers get', '/api/v1/users/me/targets'
end
