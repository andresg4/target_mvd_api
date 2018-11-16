class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_for conversation if params[:room_id].present?
  end

  def send_message(data)
    data_message = data['message']
    raise 'No message!' if data_message.blank?

    Message.create!(
      conversation: conversation,
      user: current_user,
      body: data_message
    )
  end

  # Helpers

  def conversation
    Conversation.find_by_id(params[:room_id])
  end
end
