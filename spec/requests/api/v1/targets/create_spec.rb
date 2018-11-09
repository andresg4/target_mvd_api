require 'rails_helper'
require 'json'

describe 'POST api/v1/targets', type: :request do
  let(:params)     { FactoryBot.attributes_for(:target_create) }
  let(:user)       { create(:user) }
  let(:user_match) { create(:user_with_devices) }
  let(:target)     { create(:target_user, user: user_match) }
  let(:params_match) { params }

  before do
    user.confirm
    user_match.confirm
  end

  context 'valid request' do
    subject { post api_v1_targets_path, params: params, headers: headers_aux(user), as: :json }

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
      expect(json).not_to be_empty
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
        params_match[:target][:latitude] = target.latitude + 0.0001
        params_match[:target][:longitude] = target.longitude + 0.0001
        params_match[:target][:topic_id] = target.topic_id
        post api_v1_targets_path, params: params_match, headers: headers_aux(user), as: :json
      end

      it 'returns target information' do
        new_target = Target.find_by_title(params_match[:target][:title])
        expect(json['id']).to eq(new_target.id)
        expect(json['title']).to eq(new_target.title)
        expect(json['radius']).to eq(new_target.radius)
        expect(json['latitude'].to_f).to eq(new_target.latitude.to_f)
        expect(json['longitude'].to_f).to eq(new_target.longitude.to_f)
        expect(json['topic_id']).to eq(new_target.topic_id)
        expect(json['user_id']).to eq(new_target.user_id)
      end

      it 'returns matched target information' do
        expect(json['match_targets'][0]['id']).to eq(target.id)
        expect(json['match_targets'][0]['latitude'].to_f).to eq(target.latitude.to_f)
        expect(json['match_targets'][0]['longitude'].to_f).to eq(target.longitude.to_f)
        expect(json['match_targets'][0]['radius']).to eq(target.radius)
        expect(json['match_targets'][0]['title']).to eq(target.title)
        expect(json['match_targets'][0]['topic_id']).to eq(target.topic_id)
        expect(json['match_targets'][0]['user_id']).to eq(target.user_id)
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
                   FactoryBot.attributes_for(:target_create)
end
