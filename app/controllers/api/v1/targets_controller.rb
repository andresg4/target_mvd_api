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
        @matched_targets = @target.match_targets
        devices_id = @matched_targets.flat_map { |target| target.user.devices.pluck(:id) }.uniq
        notify(devices_id) unless devices_id.empty?
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

      def notify(devices_id)
        NotificationService.new(current_user).notify_match(devices_id)
      end
    end
  end
end
