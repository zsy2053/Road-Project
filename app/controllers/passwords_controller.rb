class PasswordsController < ApplicationController
  def forgot
    if params[:email].nil?
      return render json: {error: 'Email not present'}
    end

    @user = User.find_by email: params[:email].downcase

    if @user
      @user.send_reset_password_instructions
      render json: {status: 'ok'}, status: :ok
    else
      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s
    user = User.find_by(reset_password_token: token)
    
    if user && user.reset_password_period_valid?
      if user.reset_password(params[:password], params[:password])
        render json: { status: 'ok' }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error:  'invalid user/token' }, status: :unprocessable_entity
    end
  end
end
