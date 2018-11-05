module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, only: %i[update targets]

      def show; end

      def update
        user.update!(user_params)
        render partial: 'show', locals: { user: current_user }, status: :ok
      end

      def targets
        @targets = current_user.targets
      end

      private

      def user_params
        params.permit(:name, :email, :password)
      end

      def user
        @user ||= user_id.present? ? User.find(user_id) : current_user
      end

      def user_id
        params[:id]
      end

      rescue_from ActiveRecord::RecordNotUnique do
        render json: { errors: { email: [I18n.t('errors.messages.taken')] } },
               status: :unprocessable_entity
      end
    end
  end
end
