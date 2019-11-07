class SignupController < ApplicationController
  def create
    # creates a new user object
    user = User.new(user_params)
    # if user saved, assign payload, create session, and tokens
    # set session associated cookie and return login token
    # else throw error message
    if user.save 
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      # confirms user is logged in 
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                        httponly: true,
                      secrue: Rails.env.production? )

      render json: { csrf: tokens[:csrf]}
      else
        render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
  end

  private

    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
