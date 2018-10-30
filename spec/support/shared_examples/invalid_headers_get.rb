RSpec.shared_examples 'invalid headers get' do |path_name|
  let(:user)  { create(:user) }

  before      { user.confirm }

  context 'invalid request' do
    context 'without access-token' do
      before { get path_name, headers: headers_aux(user).except('access-token'), as: :json }

      it 'returns status 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(json['errors'][0]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'without client' do
      before { get path_name, headers: headers_aux(user).except('client'), as: :json }

      it 'returns status 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(json['errors'][0]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end

    context 'without uid' do
      before { get path_name, headers: headers_aux(user).except('uid'), as: :json }

      it 'returns status 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error message' do
        expect(json['errors'][0]).to eq(I18n.t('devise.failure.unauthenticated'))
      end
    end
  end
end
