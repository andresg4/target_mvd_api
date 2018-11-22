require 'rails_helper'

describe RoomChannel, type: :channel do
  let!(:user)         { create(:user) }
  let!(:conversation) { create(:conversation, user_one: user) }

  it 'successfully subscribes' do
    subscribe(room_id: conversation.id)
    expect(subscription).to be_confirmed
  end

  it 'successfully performs sending a message' do
    stub_connection(current_user: user)
    subscribe(room_id: conversation.id)

    perform :send_message, message: 'Hello'
    expect(Message.last.body).to eq('Hello')
  end
end
