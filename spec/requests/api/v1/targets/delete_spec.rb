require 'rails_helper'

describe 'DELETE api/v1/targets/:id', type: :request do
  let(:user) { create(:user_with_targets) }

  before                  { user.confirm }

  context 'valid request' do
    subject do
      delete api_v1_target_path(id: user.targets.last.id),
             headers: headers_aux(user),
             as: :json
    end

    it 'returns status 204 No Content' do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it 'deletes the target' do
      expect { subject }.to change { user.targets.count }.by(-1)
    end
  end

  context 'invalid request' do
    context 'target does not exists' do
      subject do
        delete api_v1_target_path(id: Target.last.id + 1),
               headers: headers_aux(user),
               as: :json
      end

      it 'returns status 404 Not Found' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns error message' do
        subject
        expect(json['errors']).to eq(I18n.t('api.errors.not_found'))
      end

      it 'does not delete any target' do
        expect { subject }.to_not change { user.targets.count }
      end
    end

    context 'invalid header' do
      context 'without access-token' do
        before do
          delete api_v1_target_path(id: user.targets.first.id),
                 headers: headers_aux(user).except('access-token'),
                 as: :json
        end

        it 'returns status 401 Unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns error message' do
          expect(json['errors'][0]).to eq(I18n.t('devise.failure.unauthenticated'))
        end
      end

      context 'without client' do
        before do
          delete api_v1_target_path(id: user.targets.first.id),
                 headers: headers_aux(user).except('client'),
                 as: :json
        end

        it 'returns status 401 Unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns error message' do
          expect(json['errors'][0]).to eq(I18n.t('devise.failure.unauthenticated'))
        end
      end

      context 'without uid' do
        before do
          delete api_v1_target_path(id: user.targets.first.id),
                 headers: headers_aux(user).except('uid'),
                 as: :json
        end

        it 'returns status 401 Unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns error message' do
          expect(json['errors'][0]).to eq(I18n.t('devise.failure.unauthenticated'))
        end
      end
    end
  end
end
