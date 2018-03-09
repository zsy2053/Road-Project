class MovementsController < ApplicationController
  before_action :authenticate_request!

  before_action :set_movement, only: [:update, :show]

  rescue_from CanCan::AccessDenied, with: :not_authorized

  # GET /back_orders/1
  def show
    authorize! :read, @movement
    render json: @movement
  end

  #PUT /movements/1
  def update
    authorize! :update, @movement

    if !update_params.nil? and @movement.update(update_params)
      render json: @movement
    elsif current_user.station?
      @movement = Movement.find(params[:id])
      @movement.update(:percent_complete => params[:percent_complete])
      render json: @movement
    else
      render json: @movement.errors, status: :unprocessable_entity
    end
  end

  protected

  def not_authorized
    head :forbidden
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_movement
    @movement = Movement.find(params[:id])
  end

  def update_params
    if current_user.supervisor?
      params.require(:movement).permit(:production_critical).empty? ? nil : params.require(:movement).permit(:production_critical)
    elsif current_user.quality?
      params.require(:movement).permit(:quality_critical).empty? ? nil : params.require(:movement).permit(:quality_critical)
    else
      nil
    end
  end
end
