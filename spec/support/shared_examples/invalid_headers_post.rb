RSpec.shared_examples 'invalid headers post' do |path_name, params|
  let(:user)  { create(:user) }

  before      { user.confirm }

  context 'invalid request' do
    context 'without access-token' do
      before do
        post path_name,
             params: params,
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
        post path_name,
             params: params,
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
        post path_name,
             params: params,
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
