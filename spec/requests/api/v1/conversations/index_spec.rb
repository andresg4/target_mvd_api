require 'rails_helper'

describe 'GET api/v1/conversations', type: :request do
  let(:user)  { create(:user) }
  let!(:list_sent) { FactoryBot.create_list(:conversation, 5, user_one: user) }
  let!(:list_received) { FactoryBot.create_list(:conversation, 5, user_two: user) }

  before { user.confirm }

  context 'valid request' do
    before { get api_v1_conversations_path, headers: headers_aux(user), as: :json }

    it 'returns status 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns conversations' do
      expect(json['conversations'].map { |conversation| conversation['id'] })
        .to match_array((list_sent + list_received).pluck(:id))
    end
  end
  include_examples 'invalid headers get', '/api/v1/conversations'
end
