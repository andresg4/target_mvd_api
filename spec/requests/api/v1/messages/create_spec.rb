require 'rails_helper'

describe 'POST api/v1/messages', type: :request do
  let(:params)                   { FactoryBot.attributes_for(:message_create) }
  let(:user)                     { create(:user) }
  let(:user_match)               { create(:user) }
  let(:conversation)             { create(:conversation, user_one: user, user_two: user_match) }
  let(:conversation_other_users) do
    create(:conversation, user_one: create(:user), user_two: create(:user))
  end

  before do
    user.confirm
    user_match.confirm
  end

  context 'valid request' do
    before do
      params[:message][:conversation_id] = conversation.id
    end

    subject { post api_v1_messages_path, params: params, headers: headers_aux(user), as: :json }

    it 'returns status 200 OK' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'creates the message' do
      expect { subject }.to change { Message.count }.by(1)
    end

    it 'saves the message correctly' do
      subject
      new_message = Message.last
      expect(new_message.body).to eq(params[:message][:body])
      expect(new_message.conversation_id).to eq(params[:message][:conversation_id])
      expect(new_message.user_id).to eq(user.id)
    end

    it 'returns message id' do
      subject
      expect(json['messsage_id']).to eq(Message.last.id)
    end
  end

  context 'invalid request' do
    context 'conversation does not exists' do
      before do
        params[:message][:conversation_id] = Conversation.last.id + 1
        post api_v1_messages_path, params: params, headers: headers_aux(user), as: :json
      end

      it 'returns status 404 Not Found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(json['errors']).to eq(I18n.t('api.errors.not_found'))
      end
    end

    context 'conversation belongs to other users' do
      before do
        params[:message][:conversation_id] = conversation_other_users.id
        post api_v1_messages_path, params: params, headers: headers_aux(user), as: :json
      end

      it 'returns status 404 Not Found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        expect(json['errors']).to eq(I18n.t('api.errors.not_found'))
      end
    end
  end
end
