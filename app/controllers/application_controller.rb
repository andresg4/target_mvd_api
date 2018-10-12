class ApplicationController < ActionController::API
  # protect_from_forgery with: :exception
  before_action :authenticate_user!
  rescue_from ArgumentError, with: :record_not_found

  private

  def record_not_found(error)
    render json: { error: error.message }, status: :bad_request
  end
end
