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
    
    # keep track of previous operator ids
    old_ids = @position.operators.pluck(:id)
    
    # attempt to update position to update foreign keys on operators
    if @position.update(operators: Operator.where(id: params[:operator_ids]))
      # update the updated_at attributes for the operators removed from the position since Rails won't
      removed_ids = if params[:operator_ids].nil? then old_ids else (old_ids - params[:operator_ids]) end
      Operator.where(id: removed_ids).map(&:touch)
      
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
