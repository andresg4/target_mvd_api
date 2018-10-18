module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      def render_create_success
        render 'create_success', status: :ok
      end

      def render_create_error_not_confirmed
        render_error(401, I18n.t('devise_token_auth.sessions.not_confirmed',
                                 email: @resource.email))
      end

      def render_create_error_account_locked
        render_error(401, I18n.t('devise.mailer.unlock_instructions.account_lock_msg'))
      end

      def render_create_error_bad_credentials
        render_error(401, I18n.t('devise_token_auth.sessions.bad_credentials'))
      end

      def render_error(status, message, _data = nil)
        render json: { errors: [message] }, status: status
      end
    end
  end
end
