module Api
  module V1
    class TopicsController < Api::V1::ApiController
      before_action :authenticate_user!

      def index
        @topics = Topic.all
      end
    end
  end
end
