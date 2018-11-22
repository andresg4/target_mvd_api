class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      id: message.id,
      body: message.body,
      user: message.user
    }
    RoomChannel.broadcast_to(message.conversation, payload)
  end
end
