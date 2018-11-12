module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_conversation, only: [:create]
      before_action :set_conversation_messages, only: [:index]

      def create
        current_user_id = current_user.id
        unless [@conversation.user_one.id, @conversation.user_two.id].include? current_user_id
          return render_error
        end

        @message = @conversation.messages.create!(user_id: current_user_id,
                                                  body: message_params[:body])
      end

      def index
        @messages = @conversation.messages
      end

      private

      def set_conversation
        @conversation = Conversation.find(message_params[:conversation_id])
      end

      def set_conversation_messages
        conversation_id = params[:conversation_id]
        @conversation = current_user.sent_conversations.find_by_id(conversation_id) ||
                        current_user.received_conversations.find(conversation_id)
      end

      def message_params
        params.require(:message).permit(:body, :conversation_id)
      end

      def render_error
        render json: { errors: I18n.t('api.errors.not_found') }, status: :not_found
      end
    end
  end
end
