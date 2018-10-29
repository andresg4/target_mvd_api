require 'rails_helper'

RSpec.shared_examples 'index examples' do |class_name, resource_name, path_name|
  let(:user)  { create(:user) }
  let!(:list) { FactoryBot.create_list(resource_name, 10) }

  before { user.confirm }

  context 'valid request' do
    before { get path_name, headers: headers_aux(user), as: :json }

    it 'returns status 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns resources' do
      expect(json).not_to be_empty
      expect(json[class_name.to_s].size).to eq(list.size)
      expect(json[class_name.to_s].map { |r| r['id'] })
        .to match_array(list.pluck(:id))
    end
  end
end
