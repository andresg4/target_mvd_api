module Api
  module V1
    class ConversationsController < ApplicationController
      before_action :authenticate_user!

      def index
        @conversations = current_user.conversations
      end
    end
  end
end
