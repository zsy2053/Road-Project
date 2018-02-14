class AuthenticationController < ApplicationController
  def authenticate_user
    user = User.find_for_database_authentication(username: params[:username])
  
    if user
      if user.valid_password?(params[:password]) && user.active_for_authentication?
        render json: payload(user)
      elsif !user.active_for_authentication?
        render_error(['Your account has been suspended. Please contact your administrator'], :locked)
      elsif !user.valid_password?(params[:password])
        render_error(['Invalid Username/Password'], :unauthorized)
      else
        render_error(['Something unexpected happened!'], :expectation_failed)
      end
    else
      render_error(['User not found'], :not_found)
    end
  end

  private
  
  def render_error(error_msg, status)
    render json: {errors: error_msg}, status: status
  end
  
  def payload(user)
    return nil unless user and user.id
    {
      auth_token: JsonWebToken.encode({user_id: user.id}),
      user: {id: user.id, email: user.email, username: user.username, role: user.role}
    }
  end
end
