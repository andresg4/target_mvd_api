require 'rails_helper'

describe 'GET api/v1/conversations/:id/messages', type: :request do
  let(:user)                      { create(:user_with_devices) }
  let(:user_match)                { create(:user_with_devices) }
  let!(:conversation_sent) do
    FactoryBot.create(:conversation, user_one: user, user_two: user_match)
  end
  let!(:conversation_received) do
    FactoryBot.create(:conversation, user_one: user_match, user_two: user)
  end
  let!(:messages_sent_first) do
    FactoryBot.create_list(:message, 5, user_id: user.id, conversation_id: conversation_sent.id)
  end
  let!(:messages_received_first) do
    FactoryBot.create_list(:message, 5, user_id: user_match.id,
                                        conversation_id: conversation_sent.id)
  end
  let!(:messages_sent_second) do
    FactoryBot.create_list(:message, 5, user_id: user.id, conversation_id: conversation_received.id)
  end
  let!(:messages_received_second) do
    FactoryBot.create_list(:message, 5, user_id: user_match.id,
                                        conversation_id: conversation_received.id)
  end

  before do
    user.confirm
    user_match.confirm
  end

  context 'valid request' do
    context 'sent conversation' do
      before do
        get api_v1_conversation_messages_path(conversation_id: conversation_sent.id),
            headers: headers_aux(user), as: :json
      end

      it 'returns status 200 OK' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns messages' do
        expect(json['messages'].map { |message| message['id'] })
          .to match_array((messages_sent_first + messages_received_first).pluck(:id))
      end
    end

    context 'received conversation' do
      before do
        get api_v1_conversation_messages_path(conversation_id: conversation_received.id),
            headers: headers_aux(user), as: :json
      end

      it 'returns status 200 OK' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns messages' do
        expect(json['messages'].map { |message| message['id'] })
          .to match_array((messages_sent_second + messages_received_second).pluck(:id))
      end
    end
  end
  include_examples 'invalid headers get', '/api/v1/conversations'
end
