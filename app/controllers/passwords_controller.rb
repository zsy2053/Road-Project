class PasswordsController < ApplicationController
  def forgot
    # Use 412, 409 and 406 represent different email error. 404 is not using because 404 may represent other scenarios.
    if params[:email].blank?
      return render json: {error: ['Email not present']}, status: :precondition_failed #412
    end

    unless Devise::email_regexp.match?(params[:email])
      return render json: {error: ['Invalid email address format']}, status: :conflict #409
    end

    @user = User.find_by email: params[:email].downcase

    if @user
      @user.send_reset_password_instructions
      render json: {status: 'ok'}, status: :ok
    else
      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_acceptable #406
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
