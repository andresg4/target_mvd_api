module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      rescue_from Koala::Facebook::AuthenticationError, with: :render_error_not_authorized
      rescue_from ActiveRecord::RecordNotUnique, with: :render_error_already_registered
      rescue_from Koala::Facebook::ClientError, with: :render_error_not_authorized

      def facebook
        user_params = FacebookService.new(params[:access_token]).profile
        return render_error_email unless user_params[:email].present?

        @resource = User.from_social_provider('facebook', user_params)
        custom_sign_in
      end

      def custom_sign_in
        @resource.skip_confirmation!
        sign_in(:user, @resource, store: false, bypass: false)
        @resource.save!
        new_auth_header = @resource.create_new_auth_token
        response.headers.merge!(new_auth_header)
        render_create_success
      end

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

      def new
        render_error
      end

      def render_error_email
        render_error(:unauthorized, I18n.t('api.facebook.missing_permissions_to_get_email'))
      end

      def render_error_not_authorized
        render_error(:forbidden, I18n.t('api.facebook.not_authorized'))
      end

      def render_error_already_registered
        render_error(:bad_request, I18n.t('api.facebook.already_registered'))
      end
    end
  end
end
