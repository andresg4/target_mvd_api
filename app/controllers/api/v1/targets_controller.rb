module Api
  module V1
    class TargetsController < ApplicationController
      before_action :authenticate_user!
      helper_method :target

      def index
        @targets = Target.all
      end

      def show; end

      def create
        @target = current_user.targets.create!(target_params)
        render :show
      end

      def destroy
        target.destroy
        head :no_content
      end

      private

      def target
        @target ||= current_user.targets.find(params[:id])
      end

      def target_params
        params.require(:target).permit(:topic_id, :title, :radius,
                                       :latitude, :longitude)
      end
    end
  end
end
