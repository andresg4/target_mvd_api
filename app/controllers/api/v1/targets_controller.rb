module Api
  module V1
    class TargetsController < Api::V1::ApiController
      before_action :authenticate_user!
      helper_method :target

      def index
        @targets = current_user.targets
      end

      def show; end

      def create
        @target = current_user.targets.create!(target_params)
        @matched_targets = @target.match_targets
        unless @matched_targets.empty?
          create_conversations_match
          devices_id = @matched_targets.flat_map { |target| target.user.devices.pluck(:id) }.uniq
          notify(devices_id)
        end
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
        NotifyMatchTargetJob.perform_later(current_user, devices_id) unless devices_id.empty?
      end

      def create_conversations_match
        MatchService.new(current_user, @matched_targets).create_conversations
      end
    end
  end
end
