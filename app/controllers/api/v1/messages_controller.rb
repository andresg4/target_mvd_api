module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authenticate_user!
      before_action :conversation, only: [:index]

      def index
        @messages = @conversation.messages
      end

      private

      def conversation
        @conversation ||= current_user.conversations.find(conversation_id)
      end

      def conversation_id
        params[:conversation_id]
      end
    end
  end
end
