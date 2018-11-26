module Api
  module V1
    class ConversationsController < Api::V1::ApiController
      before_action :authenticate_user!

      def index
        @conversations = current_user.conversations
      end
    end
  end
end
