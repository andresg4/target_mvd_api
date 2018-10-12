module Api
  module V1
    class UsersController < ApplicationController
      def create
        User.new(user_params)
      end

      private

      def user_params
        params.require(:user).permit(:username, :email, :gender, :password)
      end
    end
  end
end
