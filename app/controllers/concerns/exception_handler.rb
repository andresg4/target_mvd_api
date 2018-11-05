module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      render json: { errors: I18n.t('api.errors.not_found') }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      render json: { errors: error.record.errors }, status: :unprocessable_entity
    end

    rescue_from ActionController::ParameterMissing do |error|
      render json: { errors: error.record.errors }, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotUnique do
      render json: { errors: I18n.t('api.errors.not_unique') }, status: :unprocessable_entity
    end
  end
end
