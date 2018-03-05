class StopReasonsController < ApplicationController
  before_action :authenticate_request!

  rescue_from CanCan::AccessDenied, with: :not_authorized
  # GET /stop_reasons
  def index
    authorize! :read, StopReason
    @stop_reasons = StopReason.accessible_by(current_ability)
    render json: @stop_reasons
  end

  # GET /stop_reasons/1
  def show
    @stop_reason = StopReason.find(params[:id])
    authorize! :read, @stop_reason
    render json: @stop_reason
  end

  protected

  def not_authorized
    head :forbidden
  end
end
