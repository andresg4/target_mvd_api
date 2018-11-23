require 'rails_helper'
require 'json'

describe 'POST api/v1/targets', type: :request do
  let(:params) do
    { target: FactoryBot.attributes_for(:target, user_id: user.id, topic_id: topic.id) }
  end

  let(:user)       { create(:user_with_devices) }
  let(:user_match) { create(:user_with_devices) }
  let(:topic)      { create(:topic) }

  let(:target) do
    create(:target, user: user_match, latitude: params[:target][:latitude] + 0.0001,
                    longitude: params[:target][:longitude] + 0.0001,
                    topic_id: params[:target][:topic_id])
  end

  before do
    user.confirm
    user_match.confirm
  end

  context 'valid request' do
    subject do
      post api_v1_targets_path, params: params,
                                headers: headers_aux(user), as: :json
    end

    it 'returns status 200 OK' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'creates the target' do
      expect { subject }.to change { Target.count }.by(1)
    end

    it 'saves the target correctly' do
      subject
      new_target = Target.find_by_title(params[:target][:title])
      expect(new_target.radius).to eq(params[:target][:radius].to_f)
      expect(new_target.latitude.to_f).to eq(params[:target][:latitude].round(6))
      expect(new_target.longitude.to_f).to eq(params[:target][:longitude].round(6))
      expect(new_target.topic_id).to eq(params[:target][:topic_id])
    end

    it 'returns target information' do
      subject
      new_target = Target.find_by_title(params[:target][:title])
      expect(json['id']).to eq(new_target.id)
      expect(json['title']).to eq(new_target.title)
      expect(json['radius']).to eq(new_target.radius)
      expect(json['latitude'].to_f).to eq(new_target.latitude.to_f)
      expect(json['longitude'].to_f).to eq(new_target.longitude.to_f)
      expect(json['topic_id']).to eq(new_target.topic_id)
      expect(json['user_id']).to eq(new_target.user_id)
      expect(json['match_targets']).to be_empty
    end

    context 'with matched target' do
      before do
        target.save!
      end

      it 'returns target information' do
        subject
        new_target = Target.find_by_title(params[:target][:title])
        expect(json['id']).to eq(new_target.id)
        expect(json['title']).to eq(new_target.title)
        expect(json['radius']).to eq(new_target.radius)
        expect(json['latitude'].to_f).to eq(new_target.latitude.to_f)
        expect(json['longitude'].to_f).to eq(new_target.longitude.to_f)
        expect(json['topic_id']).to eq(new_target.topic_id)
        expect(json['user_id']).to eq(new_target.user_id)
      end

      it 'returns matched target information' do
        subject
        expect(json['match_targets'][0]['id']).to eq(target.id)
        expect(json['match_targets'][0]['latitude'].to_f).to eq(target.latitude.to_f)
        expect(json['match_targets'][0]['longitude'].to_f).to eq(target.longitude.to_f)
        expect(json['match_targets'][0]['radius']).to eq(target.radius)
        expect(json['match_targets'][0]['title']).to eq(target.title)
        expect(json['match_targets'][0]['topic_id']).to eq(target.topic_id)
        expect(json['match_targets'][0]['user_id']).to eq(target.user_id)
      end

      context 'creates new conversation' do
        it 'creates the conversation' do
          expect { subject }.to change { Conversation.count }.by(1)
        end

        it 'the conversation is between the two users' do
          subject
          conversation = Conversation.last
          expect(conversation.user_one_id).to eq(user.id)
          expect(conversation.user_two_id).to eq(user_match.id)
        end
      end

      it 'enqueue notification job' do
        ActiveJob::Base.queue_adapter = :test
        expect {
          subject
        }.to have_enqueued_job
      end
    end
  end

  context 'invalid request' do
    context 'exists target with same title' do
      before do
        post api_v1_targets_path, params: params, headers: headers_aux(user), as: :json
        post api_v1_targets_path, params: params, headers: headers_aux(user), as: :json
      end

      it 'returns status 422 Unprocessable Entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json['errors']['title'][0]).to eq(I18n.t('activerecord.errors.messages.taken'))
      end
    end

    context 'missing all parameters but user id' do
      before do
        params_error = { target: params[:target].except(:title, :radius,
                                                        :latitude, :longitude, :topic_id) }
        post api_v1_targets_path, params: params_error, headers: headers_aux(user), as: :json
      end

      it 'returns status 422 Unprocessable Entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json['errors']['title'][0]).to eq(I18n.t('activerecord.errors.messages.blank'))
        expect(json['errors']['radius'][0]).to eq(I18n.t('activerecord.errors.messages.blank'))
        expect(json['errors']['latitude'][0]).to eq(I18n.t('activerecord.errors.messages.blank'))
        expect(json['errors']['longitude'][0]).to eq(I18n.t('activerecord.errors.messages.blank'))
        expect(json['errors']['topic'][0]).to eq(I18n.t('activerecord.errors.messages.required'))
      end
    end

    context 'missing all parameters but topic id' do
      before do
        params_error = { target: params[:target].except(:title, :radius,
                                                        :latitude, :longitude, :user_id) }
        post api_v1_targets_path, params: params_error, headers: headers_aux(user), as: :json
      end

      it 'returns status 422 Unprocessable Entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message' do
        expect(json['errors']['title'][0]).to eq(I18n.t('activerecord.errors.messages.blank'))
        expect(json['errors']['radius'][0]).to eq(I18n.t('activerecord.errors.messages.blank'))
        expect(json['errors']['latitude'][0]).to eq(I18n.t('activerecord.errors.messages.blank'))
        expect(json['errors']['longitude'][0]).to eq(I18n.t('activerecord.errors.messages.blank'))
      end
    end
  end

  context 'user exceeds limit of targets' do
    before do
      user_with_targets = FactoryBot.create(:user_with_targets)
      post api_v1_targets_path, params: params, headers: headers_aux(user_with_targets), as: :json
    end

    it 'returns status 422 Unprocessable Entity' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns error message' do
      expect(json['errors']['user'][0])
        .to eq(I18n.t('activerecord.errors.models.target.attributes.user.exceeded_quota'))
    end
  end

  include_examples 'invalid headers post', '/api/v1/targets',
                   target: FactoryBot.attributes_for(:target)
end
