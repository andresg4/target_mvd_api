module Api
  module V1
    class DevicesController < Api::V1::ApiController
      def create
        current_user.devices.create!(device_params)
      end

      private

      def device_params
        params.require(:device).permit(:device_id)
      end
    end
  end
end
