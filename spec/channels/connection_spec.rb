require 'rails_helper'

describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }

  before(:each) do
    user.confirm
    @auth = user.create_new_auth_token
  end

  it 'successfully connects' do
    connect "/cable?access-token=#{@auth['access-token']}&client=#{@auth['client']}" \
            "&uid=#{@auth['uid']}"
    expect(connection.current_user).to eq(user)
  end

  it 'rejects connection' do
    expect { connect '/cable' }.to have_rejected_connection
  end
end
