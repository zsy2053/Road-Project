class OperatorsController < ApplicationController
  before_action :authenticate_request!

  rescue_from CanCan::AccessDenied, with: :not_authorized

  # GET /operators
  def index
    authorize! :read, Operator
    @operators = Operator.accessible_by(current_ability)
    render json: @operators, except: :badge
  end

  # GET /operators/1
  def show
    @operator = Operator.find(params[:id])
    authorize! :read, @operator
    render json: @operator, except: :badge
  end

  # POST /operators
  def create
    authorize! :create, Operator
    @operator = Operator.new(operator_params)
    if @operator.save
      render json: @operator, except: :badge, status: :created, location: @operator
    else
      render json: @operator.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /operators/1
  def update
    @update_operator = Operator.find(params[:id])
    authorize! :update, @update_operator
    if @update_operator.update_attributes(operator_params)
      render json: @update_operator, except: :badge
    else
      render json: @update_operator.errors, status: :unprocessable_entity
    end
  end

  # DELETE /operators/1
  # def destroy
  #   @operator.destroy
  # end

  # GET USER WITH BADGE ID
  def showbadge
    authorize! :read, Operator
    @operator = Operator.find_by_badge(params[:badge])
    if @operator
      render json: @operator, except: :badge
    else
      render json: {error: ['Cannot find user']}, status: :unprocessable_entity
    end
  end

  protected

  def not_authorized
    head :forbidden
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operator
      @operator = Operator.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def operator_params
      params.require(:operator).permit(
        :first_name,
        :last_name,
        :employee_number,
        :badge,
        :suspended,
        :site_id
      )
    end
end
