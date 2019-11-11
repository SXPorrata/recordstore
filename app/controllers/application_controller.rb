class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization # authorization gem
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private
    # helper to access current user
    def current_user
      @current_user ||= User.find(payload['user_id'])
    end

    def not_authorized
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
end
