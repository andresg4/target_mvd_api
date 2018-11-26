module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      skip_before_action :verify_authenticity_token

      def render_create_success
        render 'create_success', status: :ok
      end

      def render_create_error
        render 'create_error', status: :unprocessable_entity
      end

      def render_error(status, message, _data = nil)
        render json: { errors: message }, status: status
      end

      def sign_up_params
        params.permit(:email, :password, :password_confirmation,
                      :name, :gender)
      end
    end
  end
end
