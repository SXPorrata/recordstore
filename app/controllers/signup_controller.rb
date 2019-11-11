class SignupController < ApplicationController
  def create
    # creates a new user object with permitted params
    user = User.new(user_params)

    if user.save 
      #  assign payload as user id
      payload = { user_id: user.id }
      #new token based session using payload & JWTSessions
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      # set cookie with our JWTSession token
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                        httponly: true,
                      secrue: Rails.env.production? )

      # render JSON & CSRF token to avoid cross origin request vulnerabilities
      render json: { csrf: tokens[:csrf]}
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
