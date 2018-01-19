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
  
  # GET /users/1
  def show
    @user = User.find(params[:id])
    authorize! :read, @user
    render json: @user, serializer: UserSerializer
  end
  
  # POST /users
  def create
    authorize! :create, User
    
    @user = User.new(user_params)
    authorize! :create, @user if @user.valid?
    
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
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
      params.require(:user).permit(
      :username, 
      :first_name, 
      :last_name, 
      :password, 
      :role, 
      :email, 
      :site_id, 
      :employee_id, 
      :phone, 
      :suspended, 
      :ignore_password,
      {accesses_attributes: [
        :contract_id
      ]})
    end
end
