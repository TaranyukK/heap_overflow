module Api
  module V1
    class ProfilesController < ApplicationController
      skip_before_action :authenticate_user!
      skip_authorization_check

      def me
        render json: current_resource_owner
      end

      private

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
      end
    end
  end
end
