module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      before_action :set_user_by_token, only: [:update]
      skip_before_action :verify_authenticity_token
      skip_after_action :update_auth_header, only: %i[create edit]

      # this is where users arrive after visiting the password reset confirmation link
      def edit
        # if a user is not found, return nil
        @resource = with_reset_password_token(resource_params[:reset_password_token])
        if @resource&.reset_password_period_valid?
          client_id, token = @resource.create_token
          resource_config_and_save

          yield @resource if block_given?

          render_edit_success(client_id, token)
        else
          render_edit_error
        end
      end

      private

      def resource_config_and_save
        @resource.skip_confirmation! if confirmable_enabled? && !@resource.confirmed_at
        @resource.allow_password_change = true if recoverable_enabled?
        @resource.save!
      end

      def render_edit_success(client_id, token)
        user_email = @resource.email
        response_header_options = { reset_password: true }
        response_headers = build_redirect_headers(token,
                                                  client_id,
                                                  response_header_options)
        response.header.merge!(
          'access-token' => response_headers['access-token'],
          'client' => response_headers['client'],
          'uid' => user_email
        )
        render json: { email: user_email }, status: :ok
      end

      def resource_update_method
        allow_password_change = recoverable_enabled? && @resource.allow_password_change == true
        if DeviseTokenAuth.check_current_password_before_update == false || allow_password_change
          'update_attributes'
        else
          'update_with_password'
        end
      end

      def render_create_error_missing_email
        render_error(401, I18n.t('devise_token_auth.passwords.missing_email'))
      end

      def render_create_error_missing_redirect_url
        render_error(401, I18n.t('devise_token_auth.passwords.missing_redirect_url'))
      end

      def render_create_error_not_allowed_redirect_url
        response = {
          status: 'error',
          data:   resource_data
        }
        message = I18n.t('devise_token_auth.passwords.not_allowed_redirect_url',
                         redirect_url: @redirect_url)
        render_error(422, message, response)
      end

      def render_create_success
        render json: {
          success: true,
          message: I18n.t('devise_token_auth.passwords.sended', email: @email)
        }
      end

      def render_create_error(errors)
        render json: {
          success: false,
          errors: errors
        }, status: 400
      end

      def render_edit_error
        render_error(404, I18n.t('errors.messages.not_found_password'))
      end

      def render_update_error_unauthorized
        render_error(401, I18n.t('errors.messages.unauthorized_password'))
      end

      def render_update_error_password_not_required
        render_error(422, I18n.t('devise_token_auth.passwords.password_not_required',
                                 provider: @resource.provider.humanize))
      end

      def render_update_error_missing_password
        render_error(422, I18n.t('devise_token_auth.passwords.missing_passwords'))
      end

      def render_update_success
        render json: {
          success: true,
          data: resource_data,
          message: I18n.t('devise_token_auth.passwords.successfully_updated')
        }
      end

      def render_update_error
        render json: {
          success: false,
          errors: resource_errors
        }, status: 422
      end

      def with_reset_password_token(token)
        recoverable = resource_class.with_reset_password_token(token)
        recoverable.reset_password_token = token if recoverable&.reset_password_token.present?
        recoverable
      end

      def resource_params
        params.permit(:email, :reset_password_token)
      end

      def render_not_found_error
        render_error(404, I18n.t('devise_token_auth.passwords.user_not_found', email: @email))
      end

      def render_error(status, message, _data = nil)
        render json: { errors: [message] }, status: status
      end
    end
  end
end
