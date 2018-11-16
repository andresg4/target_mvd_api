module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_conversation_messages, only: [:index]

      def index
        @messages = @conversation.messages
      end

      private

      def set_conversation_messages
        conversation_id = params[:conversation_id]
        @conversation = current_user.sent_conversations.find_by_id(conversation_id) ||
                        current_user.received_conversations.find(conversation_id)
      end
    end
  end
end
