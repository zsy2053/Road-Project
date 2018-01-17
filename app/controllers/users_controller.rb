class UsersController < ApplicationController
  before_action :authenticate_request!

  before_action :set_user, only: [:show, :update, :destroy]

  rescue_from CanCan::AccessDenied, with: :not_authorized

  # GET /users
  def index
    authorize! :read, User
    @users = User.includes(accesses: :contract).accessible_by(current_ability)
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    render json: @user, serializer: UserSerializer
  end

  protected

  def not_authorized
    head :forbidden
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :email, :site_id)
    end
end
