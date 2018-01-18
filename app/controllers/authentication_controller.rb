class AuthenticationController < ApplicationController
  def authenticate_user
    user = User.find_for_database_authentication(username: params[:username])
    if user && user.valid_password?(params[:password]) && user.active_for_authentication?
      render json: payload(user)
    else
      render json: {errors: ['Invalid Username/Password']}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email, username: user.username, role: user.role}
    }
  end
end
