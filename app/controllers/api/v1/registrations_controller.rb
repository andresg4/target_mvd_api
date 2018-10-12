module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      before_action :configure_permitted_parameters, only: [:create]

      def create
        build_resource(sign_up_params)
        @saved = resource.save
        @user = resource
        return if @saved

        save_fail
        render status: :bad_request
      end

      protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[ username email gender password
                                                              password_confirmation])
      end

      def save_fail
        clean_up_passwords resource
        @validatable = devise_mapping.validatable?
        @minimum_password_length = resource_class.password_length.min if @validatable
      end
    end
  end
end
