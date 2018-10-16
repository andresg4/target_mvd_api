module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      def render_create_success
        render 'api/v1/registrations/create_success', status: :ok
      end

      def render_create_error
        render 'api/v1/registrations/create_error', status: :unprocessable_entity
      end

      def render_error(status, message, _data = nil)
        response = { errors: [message] }
        render json: response, status: status
      end
    end
  end
end
