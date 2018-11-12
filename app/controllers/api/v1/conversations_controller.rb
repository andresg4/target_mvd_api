module Api
  module V1
    class ConversationsController < ApplicationController
      before_action :authenticate_user!

      def index
        @conversations = current_user.sent_conversations + current_user.received_conversations
      end
    end
  end
end
