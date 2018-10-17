class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ArgumentError, with: :record_not_found

  protected

  def record_not_found(error)
    render json: { error: error.message }, status: :bad_request
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email gender password
                                                         password_confirmation])
  end
end
