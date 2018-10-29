module Api
  module V1
    class TargetsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_target, only: [:show]

      def index
        @targets = Target.all
      end

      def show; end

      def create
        new_target
        @target.save ? render_create_success : render_create_error
      end

      private

      def set_target
        @target = Target.find(target_params[:title])
      end

      def target_params
        params.require(:target).permit(:id, :user_id, :topic_id, :title, :radius,
                                       :latitude, :longitude)
      end

      def new_target
        @target = Target.new(target_params.except(:id))
      end

      def render_create_success
        render 'show', status: :ok
      end

      def render_create_error
        render json: { errors: @target.errors }, status: :bad_request
      end
    end
  end
end
