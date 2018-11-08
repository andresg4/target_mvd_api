module Api
  module V1
    class TargetsController < ApplicationController
      before_action :authenticate_user!
      helper_method :target

      def index
        @targets = current_user.targets
      end

      def show; end

      def create
        @target = current_user.targets.create!(target_params)
        @targets = Target.match_targets(@target)
        devices = @targets.flat_map { |target| target.user.devices }.uniq
        @devices_id = devices.flat_map(&:device_id).uniq
        notify unless devices.empty?
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

      def notify
        NotificationService.new(current_user).notify_match(@devices_id)
      end
    end
  end
end
