require 'rails_helper'

describe 'GET api/v1/targets', type: :request do
  let(:user) { create(:user_with_targets) }

  before     { user.confirm }

  context 'valid request' do
    before { get api_v1_targets_path, headers: headers_aux(user), as: :json }

    it 'returns status 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns user targets' do
      expect(json['targets'].map { |target| target['id'] })
        .to match_array(user.targets.pluck(:id))
    end
  end
  include_examples 'invalid headers get', '/api/v1/targets'
end
