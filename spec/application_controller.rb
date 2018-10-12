class ApplicationController < ActionController::API
  # respond_to :json
  # protect_from_forgery with: :exception
  before_action :authenticate_user!
  rescue_from ArgumentError, with: :argument_error

  private

  def argument_error(error)
    render json: { error: error.message }, status: :bad_request
  end
end
