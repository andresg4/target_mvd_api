module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!, only: [:targets]

      def targets
        @targets = current_user.targets
      end
    end
  end
end
