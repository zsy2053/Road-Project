class PositionsController < ApplicationController
  before_action :authenticate_request!

  rescue_from CanCan::AccessDenied, with: :not_authorized

  def show
    @position = Position.find(params[:id])
    authorize! :read, @position
    render json: @position
  end

  def update
    @position = Position.find(params[:id])
    authorize! :update, @position
    if @position.update(operators: Operator.where(id: params[:operator_ids]))
      render json: @position
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  protected

  def not_authorized
    head :forbidden
  end
end
